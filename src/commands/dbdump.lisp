(uiop:define-package #:40ants-lake/commands/dbdump
  (:use #:cl)
  (:import-from #:lake
                #:sh)
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
(in-package #:40ants-lake/commands/dbdump)


(lake:task "dbdump" ()
  (cond
    ((probe-file ".local-config.lisp")
     (load ".local-config.lisp")

     (uiop:with-output-file (stream "/proc/self/comm" :if-exists :overwrite)
       (cl:write-string "sbcl-dbdump"
         	        stream))
  
     (flet ((getenv-or-error (name)
              (or (uiop:getenv name)
                  (lake-error (format nil "File .local-config.lisp should set \"~A\" environment variable."
                                      name)))))
       (let ((dump-command
               (cond
                 ((probe-file "/usr/lib/postgresql/17/bin/pg_dump")
                  "/usr/lib/postgresql/17/bin/pg_dump")
                 (t
                  "pg_dump"))))
         (sh (fmt "~A -f db/backup.dump -Fd 'host=~A port=~A user=~A dbname=~A password=~A'"
                  dump-command
                  (getenv-or-error "DB_HOST")
                  (getenv-or-error "DB_PORT")
                  (getenv-or-error "DB_USER")
                  (getenv-or-error "DB_NAME")
                  (getenv-or-error "DB_PASSWORD"))))))
    (t
     (lake-error "There is no file .local-config.lisp"))))
