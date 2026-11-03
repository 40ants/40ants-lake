(defpackage #:40ants-lake-tests/app
  (:use #:cl #:rove)
  (:import-from #:40ants-lake/app))
(in-package #:40ants-lake-tests/app)


(deftest app-defaults
  (let ((a (40ants-lake/app:app "foo")))
    (ok (null (40ants-lake/app:app-target-host a)))
    (ok (= 3 (40ants-lake/app:app-revisions-to-keep a)))
    (ok (equal '(("bin" . "bin/")) (40ants-lake/app:app-release-paths a)))
    (ok (null (40ants-lake/app:app-extra-revisions a)))
    (ok (string= "sbcl-bin" (40ants-lake/app:app-lisp a)))
    (ok (null (40ants-lake/app:app-health-check-url a)))))


(deftest app-overrides
  (let ((a (40ants-lake/app:app "foo" :revisions-to-keep 5
                                   :target-host "dev3"
                                   :lisp "ccl-bin/1.13"
                                   :health-check-url "http://127.0.0.1:8081/")))
    (ok (= 5 (40ants-lake/app:app-revisions-to-keep a)))
    (ok (string= "dev3" (40ants-lake/app:app-target-host a)))
    (ok (string= "ccl-bin/1.13" (40ants-lake/app:app-lisp a)))))
