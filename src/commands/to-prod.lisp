(uiop:define-package #:40ants-lake/commands/to-prod
  (:use #:cl)
  (:import-from #:serapeum
                #:->)
  (:import-from #:lake)
  (:import-from #:40ants-lake/utils
                #:get-system-path
                #:get-full-path)
  (:import-from #:40ants-lake/app
                #:app
                #:app-name
                #:app-components
                #:app-target-host
                #:app-revisions-to-keep
                #:app-health-check-url
                #:build-app
                #:uses-build-lisp-p
                #:*apps*)
  (:import-from #:40ants-lake/release
                #:make-staging)
  (:import-from #:cl-ansi-text
                #:yellow
                #:green)
  (:import-from #:40ants-lake/perform
                #:perform)
  (:import-from #:40ants-lake/environment
                #:add-prod-suffix-if-needed
                #:with-environment)
  (:export #:install-release-command
           #:health-check-commands
           #:deploy-app))
(in-package #:40ants-lake/commands/to-prod)


(-> install-release-command (string string integer) (values string &optional))
(defun install-release-command (name staging keep)
  "Return the command installing STAGING as a new release of the service NAME.

The helper /usr/local/sbin/install-release is the single write entry point
into /srv/services: it copies the revision, runs the smoke test as the
service user, atomically flips `current`, restarts the service and prunes
old revisions down to KEEP."
  (format nil "sudo /usr/local/sbin/install-release ~A ~A ~A" name staging keep))


(-> health-check-commands (app) (values list &optional))
(defun health-check-commands (app)
  "Return shell commands verifying that the service of APP is alive.

Always includes `systemctl is-active`; when APP-HEALTH-CHECK-URL is set,
also a curl returning the HTTP code (000 means nothing is listening)."
  (append (list (format nil "systemctl is-active ~A" (app-name app)))
          (when (app-health-check-url app)
            (list (format nil "curl -s -o /dev/null --max-time 5 -w '%{http_code}' ~A"
                          (app-health-check-url app))))))


(-> deploy-release (app) (values &optional))
(defun deploy-release (app)
  "Build APP, assemble a staging directory and install it as a new release.

The staging directory is removed after the install; the service is
restarted by the install-release helper itself."
  (build-app app)
  (let ((staging (make-staging app (uiop:getcwd))))
    (unwind-protect
         (progn
           (lake:sh (install-release-command (app-name app)
                                             (uiop:native-namestring staging)
                                             (app-revisions-to-keep app)))
           (sleep 3)
           (dolist (command (health-check-commands app))
             (lake:sh command))
           (lake:sh (format nil "systemctl show ~A -p NRestarts" (app-name app))))
      (uiop:delete-directory-tree staging :validate t
                                  :if-does-not-exist :ignore))))


(-> deploy-legacy (app) (values &optional))
(defun deploy-legacy (app)
  "Old-style deploy: copy roswell/<name> to roswell/<name>-prod.

Used by projects without build.lisp; the caller restarts the apps via
the restart[prod] target afterwards."
  (let* ((app-name (app-name app))
         (dev-binary-name app-name)
         (prod-binary-name (with-environment (:prod)
                             (add-prod-suffix-if-needed app-name)))
         (dev-binary-path (make-pathname :directory '(:relative "roswell")
                                         :name dev-binary-name))
         (prod-binary-path (make-pathname :directory '(:relative "roswell")
                                          :name prod-binary-name)))
    (when (probe-file dev-binary-path)
      (when (probe-file prod-binary-path)
        (lake:sh (list "rm"
                       (namestring prod-binary-path))))
      (lake:sh (list "cp"
                     "--preserve=all"
                     (namestring dev-binary-path)
                     (namestring prod-binary-path))))))


(-> deploy-app (app) (values (member :release :legacy) &optional))
(defun deploy-app (app)
  "Deploy a single APP and return the deploy mode used.

Apps with build.lisp are installed as /srv/services releases via the
install-release helper; apps without it fall back to the legacy roswell
binary copying. Remote targets are not supported yet."
  (when (app-target-host app)
    (error "Remote deploy is not supported yet"))
  (if (uses-build-lisp-p (uiop:getcwd))
      (progn (deploy-release app) :release)
      (progn (deploy-legacy app) :legacy)))


(lake:task "to-prod" ()
  "Installs apps as /srv/services releases via install-release helper,
or falls back to moving legacy roswell binaries and restarting apps in
the prod environment."
  (let ((legacy-used nil))
    (loop for app in *apps*
          do (when (eq (deploy-app app) :legacy)
               (setf legacy-used t)))
    (when legacy-used
      (lake:lake :target "restart[prod]"))))
