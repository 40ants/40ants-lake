(uiop:define-package #:40ants-lake-tests/db
  (:use #:cl)
  (:import-from #:rove
                #:deftest
                #:ok
                #:testing
                #:signals)
  (:import-from #:40ants-lake/app
                #:app)
  (:import-from #:40ants-lake/errors
                #:lake-error)
  (:import-from #:40ants-lake/commands/db
                #:get-pg-conn-string
                #:service-env-path
                #:ensure-db-connection-env
                #:%parse-env-line
                #:%read-env-file
                #:%apply-service-env))
(in-package #:40ants-lake-tests/db)


(deftest test-parse-env-line ()
  (testing "Plain KEY=value"
    (multiple-value-bind (key value)
        (%parse-env-line "DB_HOST=127.0.0.1")
      (ok (equal key "DB_HOST"))
      (ok (equal value "127.0.0.1"))))
  (testing "export prefix"
    (multiple-value-bind (key value)
        (%parse-env-line "export APP_PORT=8081")
      (ok (equal key "APP_PORT"))
      (ok (equal value "8081"))))
  (testing "Comments and blank lines yield nothing"
    (multiple-value-bind (key value)
        (%parse-env-line "# comment")
      (ok (null key))
      (ok (null value)))
    (multiple-value-bind (key value)
        (%parse-env-line "   ")
      (ok (null key))
      (ok (null value))))
  (testing "Quoted values are unquoted"
    (multiple-value-bind (key value)
        (%parse-env-line "DB_PASSWORD=\"secret 42\"")
      (ok (equal key "DB_PASSWORD"))
      (ok (equal value "secret 42")))
    (multiple-value-bind (key value)
        (%parse-env-line "DB_PASSWORD='secret 42'")
      (ok (equal value "secret 42")))))


(deftest test-read-env-file ()
  (uiop:with-temporary-file (:pathname path :stream stream)
    (write-line "# settings" stream)
    (write-line "" stream)
    (write-line "DB_HOST=127.0.0.1" stream)
    (write-line "export DB_PORT=5435" stream)
    (write-line "MAX_TOKEN=\"do-not-apply\"" stream)
    (write-line "DB_NAME=\"pingvito\"" stream)
    :close-stream
    (let ((settings (%read-env-file path)))
      (testing "Keys and values are parsed"
        (ok (= (length settings) 4))
        (ok (equal (cdr (assoc "DB_HOST" settings :test #'string=))
                   "127.0.0.1"))
        (ok (equal (cdr (assoc "DB_PORT" settings :test #'string=))
                   "5435"))
        (ok (equal (cdr (assoc "DB_NAME" settings :test #'string=))
                   "pingvito"))))))


(deftest test-apply-service-env-only-db-variables ()
  (uiop:with-temporary-file (:pathname path :stream stream)
    (write-line "DB_HOST=10.0.0.1" stream)
    (write-line "DB_PORT=5435" stream)
    (write-line "DB_USER=pingvito_app" stream)
    (write-line "DB_NAME=pingvito" stream)
    (write-line "DB_PASSWORD=secret" stream)
    (write-line "MAX_TOKEN=\"do-not-apply\"" stream)
    :close-stream
    (%apply-service-env path)
    (testing "DB_* variables are applied"
      (ok (equal (uiop:getenv "DB_HOST") "10.0.0.1"))
      (ok (equal (uiop:getenv "DB_PORT") "5435"))
      (ok (equal (uiop:getenv "DB_USER") "pingvito_app"))
      (ok (equal (uiop:getenv "DB_NAME") "pingvito"))
      (ok (equal (uiop:getenv "DB_PASSWORD") "secret")))
    (testing "Non-DB variables are not applied"
      (ok (null (uiop:getenv "MAX_TOKEN"))))))


(deftest test-service-env-path ()
  (let ((app (app "pingvito")))
    (ok (equal (service-env-path app)
               "/srv/services/pingvito/config/service.env"))))


(deftest test-get-pg-conn-string ()
  (setf (uiop:getenv "DB_HOST") "127.0.0.1")
  (setf (uiop:getenv "DB_PORT") "5435")
  (setf (uiop:getenv "DB_USER") "pingvito_app")
  (setf (uiop:getenv "DB_NAME") "pingvito")
  (setf (uiop:getenv "DB_PASSWORD") "s3cret")
  (testing "Connection string includes all settings"
    (ok (equal (get-pg-conn-string)
               "'host=127.0.0.1 port=5435 user=pingvito_app dbname=pingvito password=s3cret'"))))


(deftest test-ensure-db-connection-env-errors-when-no-sources ()
  ;; The 40ants-lake checkout has no .local-config.lisp and there is no
  ;; deployed service named no-such-service, so both sources are missing.
  (ok (signals (ensure-db-connection-env (app "no-such-service"))
               'lake-error)))
