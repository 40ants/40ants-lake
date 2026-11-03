(uiop:define-package #:40ants-lake/app
  (:use #:cl)
  (:import-from #:lake)
  (:import-from #:40ants-lake/installation
                #:collect-installation-steps)
  (:import-from #:serapeum
                #:->
                #:defvar-unbound)
  (:export #:app
           #:build-app
           #:defapps
           #:app-name
           #:app-components
           #:app-target-host
           #:app-revisions-to-keep
           #:app-release-paths
           #:app-extra-revisions
           #:app-lisp
           #:app-health-check-url
           #:release-build-command
           #:delete-stale-artifact
           #:uses-build-lisp-p
           #:legacy-build-command
           #:current-app))
(in-package #:40ants-lake/app)


(defvar *apps* nil
  "Apps defined with defapps will be placed here.")


(defvar-unbound *current-app*
  "Will be bound during the call to COLLECT-INSTALLATION-STEPS generic-function.")


(defclass app ()
  ((name :initarg :name
         :type string
         :reader app-name)
   (components :initarg :components
               :type list
               :reader app-components)
   (target-host :initarg :target-host
                :type (or null string)
                :initform nil
                :reader app-target-host)
   (revisions-to-keep :initarg :revisions-to-keep
                      :type integer
                      :initform 3
                      :reader app-revisions-to-keep)
   (release-paths :initarg :release-paths
                  :type list
                  :initform '(("bin" . "bin/"))
                  :reader app-release-paths)
   (extra-revisions :initarg :extra-revisions
                    :type list
                    :initform nil
                    :reader app-extra-revisions)
   (lisp :initarg :lisp
         :type (or null string)
         :initform "sbcl-bin"
         :reader app-lisp)
   (health-check-url :initarg :health-check-url
                     :type (or null string)
                     :initform nil
                     :reader app-health-check-url)))


(defun app (name &key components
                   target-host
                   (revisions-to-keep 3)
                   (release-paths '(("bin" . "bin/")))
                   extra-revisions
                   (lisp "sbcl-bin")
                   health-check-url)
  (make-instance 'app
                 :name name
                 :components (uiop:ensure-list components)
                 :target-host target-host
                 :revisions-to-keep revisions-to-keep
                 :release-paths release-paths
                 :extra-revisions extra-revisions
                 :lisp lisp
                 :health-check-url health-check-url))



(-> release-build-command (app) (values string &optional))
(defun release-build-command (app)
  "Return the command building the release via the project's build.lisp.

build.lisp itself knows the project to build. The Lisp is passed to
Roswell with -L, taken from the LISP slot (\"sbcl-bin\" by default).
Any spec accepted by `ros run -L` works, for example \"ccl-bin/1.13\"
or a pinned \"sbcl-bin/2.5.9\". When the slot is NIL, no -L argument
is given and Roswell picks its default Lisp.

Roswell forwards everything after -- to the implementation's own
command line, and those flags are implementation specific:
--non-interactive exists on SBCL, while CCL rejects it with
\"Unknown option\" and gets only --load. That is safe because
build.lisp quits the process explicitly both on success and failure."
  (let ((lisp-spec (app-lisp app)))
    (cond ((null lisp-spec)
           "qlot exec ros run -- --non-interactive --load build.lisp")
          ((uiop:string-prefix-p "ccl" lisp-spec)
           (format nil "qlot exec ros -L ~A run -- --load build.lisp"
                   lisp-spec))
          (t
           (format nil "qlot exec ros -L ~A run -- --non-interactive --load build.lisp"
                   lisp-spec)))))


(-> uses-build-lisp-p ((or pathname string null)) (values boolean &optional))
(defun uses-build-lisp-p (root)
  "Return T when ROOT contains a build.lisp (the Deploy convention).

Projects without build.lisp keep using the legacy roswell/<name>.ros build."
  (not (null (and root
                  (uiop:file-exists-p (merge-pathnames "build.lisp" root))))))


(-> legacy-build-command (string) (values string &optional))
(defun legacy-build-command (name)
  "Return the legacy build command for projects without build.lisp."
  (format nil "qlot exec ros dynamic-space-size=32gb build roswell/~A.ros" name))


(-> delete-stale-artifact (app) (values boolean &optional))
(defun delete-stale-artifact (app)
  "Delete the previous bin/<name> artifact, if any.

ASDF skips deploy-op when its output file is newer than the inputs, so
without this a build would silently keep the stale binary when nothing
tracked changed — for example right after switching the LISP slot from
one implementation to another."
  (uiop:delete-file-if-exists
   (merge-pathnames (format nil "bin/~A" (app-name app))
                    (uiop:getcwd))))


(defgeneric build-app (app)
  (:method ((app app))
    (if (uses-build-lisp-p (uiop:getcwd))
        (progn
          (delete-stale-artifact app)
          (lake:sh (release-build-command app)))
        (lake:sh (legacy-build-command (app-name app))))))


(defmacro defapps (&body apps)
  `(setf *apps*
         (list ,@apps)))


(defun current-app ()
  (unless (boundp '*current-app*)
    (error "Function CURRENT-APP should be called inside the COLLECT-INSTALLATION-STEPS call."))
  *current-app*)


(defmethod collect-installation-steps ((app app))
  (let ((*current-app* app))
    (loop for component in (app-components app)
          appending (collect-installation-steps component))))
