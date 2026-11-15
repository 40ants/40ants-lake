(uiop:define-package #:40ants-lake/commands/db
  (:use #:cl)
  (:import-from #:lake)
  (:import-from #:serapeum
                #:fmt)
  (:import-from #:str
                #:trim)
  (:import-from #:alexandria
                #:length=)
  (:import-from #:40ants-lake/app
                #:*apps*
                #:app-name)
  (:import-from #:40ants-lake/errors
                #:lake-error)
  (:export #:ensure-db-connection-env
           #:get-pg-conn-string
           #:service-env-path))
(in-package #:40ants-lake/commands/db)


(defvar *db-env-variables*
  '("DB_HOST" "DB_PORT" "DB_USER" "DB_NAME" "DB_PASSWORD" "DB_OPTIONS")
  "Connection settings fetched from the deployed service's env file.")


(defun get-app ()
  "Return the single application defined in the Lakefile."
  (or (first *apps*)
      (lake-error "There is no application defined in the Lakefile.")))


(defun service-env-path (app)
  "Path to the deployed service's environment file, readable by group art."
  (format nil "/srv/services/~A/config/service.env"
          (app-name app)))


(defun %parse-env-line (line)
  "Return (values key value) for a KEY=value or export KEY=value line,
or no values for comments and blank lines. Surrounding quotes are
stripped from the value."
  (let ((line (trim line)))
    (when (or (length= 0 line)
              (eql (char line 0) #\#))
      (return-from %parse-env-line (values nil nil)))
    (let ((line (if (uiop:string-prefix-p "export " line)
                    (subseq line 7)
                    line)))
      (let ((equals (position #\= line)))
        (when equals
          (let ((key (trim (subseq line 0 equals)))
                (value (trim (subseq line (1+ equals)))))
            (when (and (>= (length value) 2)
                       (or (and (eql (char value 0) #\")
                                (eql (char value (1- (length value))) #\"))
                           (and (eql (char value 0) #\')
                                (eql (char value (1- (length value))) #\'))))
              (setf value (subseq value 1 (1- (length value)))))
            (values (trim key) value)))))))


(defun %read-env-file (path)
  "Read KEY=value pairs from PATH into an alist."
  (when (probe-file path)
    (handler-case
        (let ((result nil))
          (with-open-file (stream path)
            (loop for line = (read-line stream nil nil)
                  while line
                  do (multiple-value-bind (key value)
                         (%parse-env-line line)
                       (when key
                         (push (cons key value) result)))))
          (nreverse result))
      (error ()
        ;; Not readable (wrong group/permissions) - treat as absent.
        nil))))


(defun %apply-service-env (path)
  "Apply DB_* variables from the env file at PATH to the process
environment. Other variables (tokens etc) are left out. Returns the
parsed settings alist."
  (let ((settings (%read-env-file path)))
    (loop for name in *db-env-variables*
          for value = (cdr (assoc name settings :test #'string=))
          when value
            do (setf (uiop:getenv name) value))
    settings))


(defun ensure-db-connection-env (app)
  "Prepare the process environment for a psql/pg_dump connection.

Sources in priority order:
1. `.local-config.lisp` in the project root (it sets DB_* variables itself).
2. `/srv/services/<name>/config/service.env` of the deployed service.
Signals a LAKE-ERROR when neither source is available."
  (cond
    ((probe-file ".local-config.lisp")
     (load ".local-config.lisp"))
    (t
     (let ((path (service-env-path app))
           (settings (%apply-service-env (service-env-path app))))
       (unless (loop for name in *db-env-variables*
                     thereis (cdr (assoc name settings :test #'string=)))
         (lake-error
          (format nil "There is no readable database configuration: neither ~A nor .local-config.lisp. Make sure the service env file exists and has group art with mode 0640."
                  path)))))))


(defun get-pg-conn-string ()
  (flet ((getenv-or-error (name)
           (or (uiop:getenv name)
               (lake-error (format nil "Database connection needs \"~A\" environment variable."
                                   name)))))
    (fmt "'host=~A port=~A user=~A dbname=~A password=~A~@[ options=~A~]'"
         (getenv-or-error "DB_HOST")
         (getenv-or-error "DB_PORT")
         (getenv-or-error "DB_USER")
         (getenv-or-error "DB_NAME")
         (getenv-or-error "DB_PASSWORD")
         (uiop:getenv "DB_OPTIONS"))))
