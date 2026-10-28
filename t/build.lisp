(defpackage #:40ants-lake-tests/build
  (:use #:cl #:rove)
  (:import-from #:40ants-lake/app))
(in-package #:40ants-lake-tests/build)


(deftest release-build-command
  (ok (string= "qlot exec ros run -- --non-interactive --load build.lisp"
               (40ants-lake/app:release-build-command "foo" nil)))
  (ok (string= "qlot exec ros -L sbcl-bin/2.5.9 run -- --non-interactive --load build.lisp"
               (40ants-lake/app:release-build-command "foo" "sbcl-bin/2.5.9"))))


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
