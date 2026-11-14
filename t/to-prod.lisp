(defpackage #:40ants-lake-tests/to-prod
  (:use #:cl #:rove)
  (:import-from #:40ants-lake/app
                #:app)
  (:import-from #:40ants-lake/commands/to-prod))
(in-package #:40ants-lake-tests/to-prod)


(deftest install-release-command-format
  (let ((script-path (40ants-lake/commands/to-prod:install-release-script-path)))
    (ok (probe-file script-path)
        "install-release helper ships with the checkout")
    (ok (string= (format nil "sudo ~A pingvito /tmp/staging-123 5"
                         script-path)
                 (40ants-lake/commands/to-prod:install-release-command
                  "pingvito" "/tmp/staging-123" 5))
        "command invokes the helper via sudo using the checkout path")))


(deftest health-check-commands-with-url
  (ok (equal (list "systemctl is-active pingvito"
                   "curl -s -o /dev/null --max-time 5 -w '%{http_code}' http://127.0.0.1:8081/")
             (40ants-lake/commands/to-prod:health-check-commands
              (40ants-lake/app:app "pingvito"
                                   :health-check-url "http://127.0.0.1:8081/")))))


(deftest health-check-commands-without-url
  (ok (equal (list "systemctl is-active pingvito")
             (40ants-lake/commands/to-prod:health-check-commands
              (40ants-lake/app:app "pingvito")))))


(deftest remote-deploy-unsupported
  (signals (40ants-lake/commands/to-prod:deploy-app
            (40ants-lake/app:app "foo" :target-host "dev3"))
    'error))
