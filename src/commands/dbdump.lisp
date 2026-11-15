(uiop:define-package #:40ants-lake/commands/dbdump
  (:use #:cl)
  (:import-from #:lake
		#:sh)
  (:import-from #:serapeum
		#:fmt)
  (:import-from #:40ants-lake/app
                #:*apps*)
  (:import-from #:40ants-lake/commands/db
                #:ensure-db-connection-env
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

  (ensure-db-connection-env (first *apps*))
  (let ((command (fmt "~A -s -f schema.sql --exclude-schema _timescaledb_internal ~A"
                      (get-dump-command)
                      (get-pg-conn-string))))
    (sh command)))


(lake:task "dbdump-backup" ()
  (uiop:with-output-file (stream "/proc/self/comm" :if-exists :overwrite)
    (cl:write-string "sbcl-dbdump"
         	     stream))

  (ensure-db-connection-env (first *apps*))
  (let ((command (fmt "mkdir -p db && ~A -f db/backup.dump -Fd ~A"
                      (get-dump-command)
                      (get-pg-conn-string))))
    (sh command)))
