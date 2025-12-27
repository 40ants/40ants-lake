(uiop:define-package #:40ants-lake/commands/dbshell
  (:use #:cl)
  (:import-from #:lake
		#:sh)
  (:import-from #:serapeum
		#:fmt)
  (:import-from #:cl-ansi-text
                #:green)
  (:import-from #:40ants-lake/app
                #:*apps*
                #:app-name
                #:build-app)
  (:import-from #:40ants-lake/errors
                #:lake-error))
(in-package #:40ants-lake/commands/dbshell)


(lake:task "dbshell" ()
  (cond
    ((probe-file ".local-config.lisp")
     (load ".local-config.lisp")

     (uiop:with-output-file (stream "/proc/self/comm" :if-exists :overwrite)
       (cl:write-string "sbcl-dbshell"
         	        stream))
  
     (flet ((getenv-or-error (name)
              (or (uiop:getenv name)
                  (lake-error (format nil "File .local-config.lisp should set \"~A\" environment variable."
                                      name)))))
       (let ((command (fmt "psql 'host=~A port=~A user=~A dbname=~A password=~A~@[ options=~A~]'"
                           (getenv-or-error "DB_HOST")
                           (getenv-or-error "DB_PORT")
                           (getenv-or-error "DB_USER")
                           (getenv-or-error "DB_NAME")
                           (getenv-or-error "DB_PASSWORD")
                           (uiop:getenv "DB_OPTIONS"))))
         (sh command))))
    (t
     (lake-error "There is no file .local-config.lisp"))))
