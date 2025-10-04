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
               :reader app-components)))


(defun app (name &key components)
  (make-instance 'app
                 :name name
                 :components (uiop:ensure-list components)))



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
