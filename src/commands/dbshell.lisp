(uiop:define-package #:40ants-lake/commands/dbshell
  (:use #:cl)
  (:import-from #:lake
		#:sh)
  (:import-from #:serapeum
		#:fmt)
  (:import-from #:cl-ansi-text
                #:green)
  (:import-from #:serapeum
                #:fmt)
  (:import-from #:40ants-lake/app
                #:*apps*
                #:app-name
                #:build-app)
  (:import-from #:40ants-lake/errors
                #:lake-error))
(in-package #:40ants-lake/commands/dbshell)


(defun get-pg-conn-string ()
  (flet ((getenv-or-error (name)
           (or (uiop:getenv name)
               (lake-error (format nil "File .local-config.lisp should set \"~A\" environment variable."
                                   name)))))
    (fmt "'host=~A port=~A user=~A dbname=~A password=~A~@[ options=~A~]'"
         (getenv-or-error "DB_HOST")
         (getenv-or-error "DB_PORT")
         (getenv-or-error "DB_USER")
         (getenv-or-error "DB_NAME")
         (getenv-or-error "DB_PASSWORD")
         (uiop:getenv "DB_OPTIONS"))))


(lake:task "dbshell" ()
  (uiop:with-output-file (stream "/proc/self/comm" :if-exists :overwrite)
    (cl:write-string "sbcl-dbshell"
         	     stream))
  
  (cond
    ((probe-file ".local-config.lisp")
     (load ".local-config.lisp")

     (let ((command (fmt "psql ~A"
                         (get-pg-conn-string))))
       (sh command)))
    (t
     (lake-error "There is no file .local-config.lisp"))))
