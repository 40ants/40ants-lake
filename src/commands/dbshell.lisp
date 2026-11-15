(uiop:define-package #:40ants-lake/commands/dbshell
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
(in-package #:40ants-lake/commands/dbshell)


(lake:task "dbshell" ()
  (uiop:with-output-file (stream "/proc/self/comm" :if-exists :overwrite)
    (cl:write-string "sbcl-dbshell"
         	     stream))

  (ensure-db-connection-env (first *apps*))
  (sh (fmt "psql ~A"
           (get-pg-conn-string))))
