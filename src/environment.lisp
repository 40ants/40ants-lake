(uiop:define-package #:40ants-lake/environment
  (:use #:cl)
  (:import-from #:serapeum
                #:defvar-unbound)
  (:import-from #:alexandria
                #:length=
                #:once-only)
  (:import-from #:str
                #:trim
                #:split)
  (:export #:assert-valid-environment
           #:with-environment
           #:add-dev-suffix-if-needed
           #:add-prod-suffix-if-needed
           #:load-env-file))
(in-package #:40ants-lake/environment)


(defvar-unbound *current-environment*
  "Will be bound during WITH-ENVIRONMENT macro body.")


(defun assert-valid-environment (env)
  (unless (member env '(:prod :dev))
    (error "Environment argument should be :PROD or :DEV. You gave ~S."
	   env)))


(defmacro with-environment ((environment) &body body)
  (once-only (environment)
    `(let ((*current-environment* (progn (assert-valid-environment ,environment)
                                         ,environment)))
       ,@body)))


(defun add-dev-suffix-if-needed (string &key (delimiter "-"))
  (case *current-environment*
    (:dev
     (concatenate 'string
                  string
                  delimiter
                  "dev"))
    (t
     string)))


(defun add-prod-suffix-if-needed (string &key (delimiter "-"))
  (case *current-environment*
    (:prod
     (concatenate 'string
                  string
                  delimiter
                  "prod"))
    (t
     string)))



(defun load-env-file ()
  "Loads .env file with lines like:

   ```
   TOKEN=foo
   PORT=100500
   ```"
  (when (probe-file ".env")
    (loop for line in (uiop:read-file-lines ".env")
          for splitted = (split "=" (trim line)
                                :limit 2)
          when (length= 2 splitted)
            do (setf (uiop:getenv (str:trim (first splitted)))
                     (str:trim (second splitted))))))
