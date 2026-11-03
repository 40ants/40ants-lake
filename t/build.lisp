(defpackage #:40ants-lake-tests/build
  (:use #:cl #:rove)
  (:import-from #:40ants-lake/app))
(in-package #:40ants-lake-tests/build)


(deftest release-build-command
  (testing "Default lisp spec is sbcl-bin"
    (ok (string= "qlot exec ros -L sbcl-bin run -- --non-interactive --load build.lisp"
                 (40ants-lake/app:release-build-command
                  (40ants-lake/app:app "foo")))))
  (testing "sbcl-pin takes precedence over the lisp slot"
    (ok (string= "qlot exec ros -L sbcl-bin/2.5.9 run -- --non-interactive --load build.lisp"
                 (40ants-lake/app:release-build-command
                  (40ants-lake/app:app "foo" :sbcl-pin "sbcl-bin/2.5.9")))))
  (testing "Any spec accepted by ros run -L can be given"
    (ok (string= "qlot exec ros -L ccl-bin/1.13 run -- --non-interactive --load build.lisp"
                 (40ants-lake/app:release-build-command
                  (40ants-lake/app:app "foo" :lisp "ccl-bin/1.13")))))
  (testing "sbcl-pin wins even when a custom lisp is given"
    (ok (string= "qlot exec ros -L sbcl-bin/2.5.9 run -- --non-interactive --load build.lisp"
                 (40ants-lake/app:release-build-command
                  (40ants-lake/app:app "foo" :sbcl-pin "sbcl-bin/2.5.9"
                                       :lisp "ccl-bin/1.13")))))
  (testing "Both slots NIL omit -L and use Roswell's default Lisp"
    (ok (string= "qlot exec ros run -- --non-interactive --load build.lisp"
                 (40ants-lake/app:release-build-command
                  (40ants-lake/app:app "foo" :lisp nil))))))


(deftest uses-build-lisp-p-dispatch
  (let ((dir (merge-pathnames (format nil "40ants-lake-test-~A/" (gensym ""))
                              (uiop:temporary-directory))))
    (ensure-directories-exist dir)
    (unwind-protect
         (progn
           (ok (null (40ants-lake/app:uses-build-lisp-p dir)))
           (with-open-file (s (merge-pathnames "build.lisp" dir) :direction :output))
           (ok (40ants-lake/app:uses-build-lisp-p dir)))
      (uiop:delete-directory-tree dir :validate t :if-does-not-exist :ignore))))
