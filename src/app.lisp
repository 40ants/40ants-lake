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
           #:app-sbcl-pin
           #:app-health-check-url
           #:release-build-command
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
   (sbcl-pin :initarg :sbcl-pin
             :type (or null string)
             :initform nil
             :reader app-sbcl-pin)
   (health-check-url :initarg :health-check-url
                     :type (or null string)
                     :initform nil
                     :reader app-health-check-url)))


(defun app (name &key components
                   target-host
                   (revisions-to-keep 3)
                   (release-paths '(("bin" . "bin/")))
                   extra-revisions
                   sbcl-pin
                   health-check-url)
  (make-instance 'app
                 :name name
                 :components (uiop:ensure-list components)
                 :target-host target-host
                 :revisions-to-keep revisions-to-keep
                 :release-paths release-paths
                 :extra-revisions extra-revisions
                 :sbcl-pin sbcl-pin
                 :health-check-url health-check-url))



(-> release-build-command (string (or null string)) (values string &optional))
(defun release-build-command (name sbcl-pin)
  "Return the command building the release via the project's build.lisp.

NAME is the app name; build.lisp itself knows the project to build.
When SBCL-PIN is given, the command pins the SBCL version with -L."
  (declare (ignore name))
  (format nil "qlot exec ros~@[ -L ~A~] run -- --non-interactive --load build.lisp"
          sbcl-pin))


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


(defgeneric build-app (app)
  (:method ((app app))
    (lake:sh (if (uses-build-lisp-p (uiop:getcwd))
                 (release-build-command (app-name app) (app-sbcl-pin app))
                 (legacy-build-command (app-name app))))))


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
