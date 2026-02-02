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


(defun get-dump-command ()
  (cond
    ((probe-file "/usr/lib/postgresql/17/bin/pg_dump")
     "/usr/lib/postgresql/17/bin/pg_dump")
    (t
     "pg_dump")))


(lake:task "dbdump-schema" ()
  (uiop:with-output-file (stream "/proc/self/comm" :if-exists :overwrite)
    (cl:write-string "sbcl-dbdump"
         	     stream))
  (cond
    ((probe-file ".local-config.lisp")
     (load ".local-config.lisp")
     
     (let ((command (fmt "~A -s -f schema.sql --exclude-schema _timescaledb_internal ~A"
                         (get-dump-command)
                         (get-pg-conn-string))))
       (sh command)))
    (t
     (lake-error "There is no file .local-config.lisp"))))


(lake:task "dbdump-backup" ()
  (uiop:with-output-file (stream "/proc/self/comm" :if-exists :overwrite)
    (cl:write-string "sbcl-dbdump"
         	     stream))
  (cond
    ((probe-file ".local-config.lisp")
     (load ".local-config.lisp")
     
     (let ((command (fmt "~A -f db/backup.dump -Fd schema.sql ~A"
                         (get-dump-command)
                         (get-pg-conn-string))))
       (sh command)))
    (t
     (lake-error "There is no file .local-config.lisp"))))
