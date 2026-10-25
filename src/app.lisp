(uiop:define-package #:40ants-lake/app
  (:use #:cl)
  (:import-from #:lake)
  (:import-from #:40ants-lake/installation
                #:collect-installation-steps)
  (:import-from #:serapeum
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



(defgeneric build-app (app)
  (:method ((app app))
    (lake:sh (format nil "qlot exec ros dynamic-space-size=32gb build roswell/~A.ros"
                     (app-name app)))))


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
