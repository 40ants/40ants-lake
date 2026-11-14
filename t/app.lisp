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


(deftest bin-ready-p
  ;; mktemp -d, as in 40ants-lake/release:%make-staging-directory,
  ;; gives a fixture root unique across processes.
  (let ((root (uiop:ensure-directory-pathname
               (pathname
                (uiop:run-program (list "mktemp" "-d")
                                  :output '(:string :stripped t))))))
    (unwind-protect
         (progn
           ;; No bin/ directory at all.
           (ok (null (40ants-lake/app:bin-ready-p root)))
           ;; Empty bin/.
           (ensure-directories-exist (merge-pathnames "bin/" root))
           (ok (null (40ants-lake/app:bin-ready-p root)))
           ;; Only shared libraries, with and without a version suffix.
           (dolist (name '("libfoo.so" "libfoo.so.1" "libfoo.so.1.5.7"))
             (with-open-file (out (merge-pathnames (format nil "bin/~A" name) root)
                                  :direction :output
                                  :if-exists :supersede)
               (write-line "ELFDATA" out)))
           (ok (null (40ants-lake/app:bin-ready-p root)))
           ;; The executable plus its libraries: releasable.
           (with-open-file (out (merge-pathnames "bin/pingvito" root)
                                :direction :output
                                :if-exists :supersede)
             (write-line "ELFDATA" out))
           (ok (40ants-lake/app:bin-ready-p root)))
      (uiop:delete-directory-tree root :validate t))))
