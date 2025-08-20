(uiop:define-package #:40ants-lake/env-val
  (:use #:cl)
  (:import-from #:40ants-lake/environment
                #:*current-environment*
                #:assert-valid-environment)
  (:export #:env-val
           #:resolve-env-value))
(in-package #:40ants-lake/env-val)


(defclass env-val ()
  ((prod-value :initarg :prod
               :initform nil
               :reader prod-value)
   (dev-value :initarg :dev
              :initform nil
              :reader dev-value)))


(defun env-val (&key prod dev)
  (make-instance 'env-val
                 :prod prod
                 :dev dev))


(defmethod print-object ((obj env-val) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream ":PROD ~S :DEV ~S"
            (prod-value obj)
            (dev-value obj))))


(defun resolve-env-value (value &key (env *current-environment*))
  (assert-valid-environment env)

  (typecase value
    (env-val
     (ecase env
       (:prod (prod-value value))
       (:dev (dev-value value))))
    (t
     value)))
