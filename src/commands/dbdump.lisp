(uiop:define-package #:40ants-lake/commands/dbdump
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
                #:lake-error)
  (:import-from #:40ants-lake/commands/dbshell
                #:get-pg-conn-string))
(in-package #:40ants-lake/commands/dbdump)


(lake:task "dbdump-schema" ()
  (uiop:with-output-file (stream "/proc/self/comm" :if-exists :overwrite)
    (cl:write-string "sbcl-dbdump"
         	     stream))
  (cond
    ((probe-file ".local-config.lisp")
     (load ".local-config.lisp")
     
     (let ((command (fmt "pg_dump -s -f schema.sql ~A"
                         (get-pg-conn-string))))
       (sh command)))
    (t
     (lake-error "There is no file .local-config.lisp"))))
