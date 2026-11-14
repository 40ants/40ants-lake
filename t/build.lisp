(defpackage #:40ants-lake-tests/build
  (:use #:cl #:rove)
  (:import-from #:40ants-lake/app))
(in-package #:40ants-lake-tests/build)


(deftest release-build-command
  (testing "Default lisp spec is sbcl-bin"
    (ok (string= "qlot exec ros -L sbcl-bin run -- --non-interactive --eval '(ql:quickload :40ants-builder)' --eval '(40ants-builder:build :foo)'"
                 (40ants-lake/app:release-build-command
                  (40ants-lake/app:app "foo")))))
  (testing "Any spec accepted by ros run -L can be given"
    (ok (string= "qlot exec ros -L ccl-bin/1.13 run -- --eval '(ql:quickload :40ants-builder)' --eval '(40ants-builder:build :foo)'"
                 (40ants-lake/app:release-build-command
                  (40ants-lake/app:app "foo" :lisp "ccl-bin/1.13")))))
  (testing "CCL gets no --non-interactive, which it rejects as an unknown option"
    (ok (not (search "--non-interactive"
                     (40ants-lake/app:release-build-command
                      (40ants-lake/app:app "foo" :lisp "ccl-bin"))))))
  (testing "A pinned spec is passed as is"
    (ok (string= "qlot exec ros -L sbcl-bin/2.5.9 run -- --non-interactive --eval '(ql:quickload :40ants-builder)' --eval '(40ants-builder:build :foo)'"
                 (40ants-lake/app:release-build-command
                  (40ants-lake/app:app "foo" :lisp "sbcl-bin/2.5.9")))))
  (testing "NIL lisp omits -L and uses Roswell's default Lisp"
    (ok (string= "qlot exec ros run -- --non-interactive --eval '(ql:quickload :40ants-builder)' --eval '(40ants-builder:build :foo)'"
                 (40ants-lake/app:release-build-command
                  (40ants-lake/app:app "foo" :lisp nil))))))


(deftest delete-stale-artifact
  (let ((dir (merge-pathnames (format nil "40ants-lake-test-~A/" (gensym ""))
                              (uiop:temporary-directory))))
    (ensure-directories-exist (merge-pathnames "bin/" dir))
    (unwind-protect
         (let ((artifact (merge-pathnames "bin/foo" dir)))
           (with-open-file (s artifact :direction :output)
             (write-line "stale" s))
           (uiop:with-current-directory (dir)
             (ok (40ants-lake/app:delete-stale-artifact
                  (40ants-lake/app:app "foo"))
                 "returns T when a stale artifact was deleted")
             (ok (null (probe-file artifact))
                 "the artifact is gone")
             (ok (null (40ants-lake/app:delete-stale-artifact
                        (40ants-lake/app:app "foo")))
                 "returns NIL when there was no artifact")))
      (uiop:delete-directory-tree dir :validate t :if-does-not-exist :ignore))))


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


(deftest builder-tract-p
  (let ((dir (merge-pathnames (format nil "40ants-lake-test-~A/" (gensym ""))
                              (uiop:temporary-directory))))
    (ensure-directories-exist dir)
    (unwind-protect
         (progn
           (testing "An app without the builder slot and without build.lisp builds via legacy roswell"
             (ok (null (40ants-lake/app:builder-tract-p
                        (40ants-lake/app:app "foo")
                        dir))))
           (testing "The builder slot turns the tract on explicitly"
             (ok (40ants-lake/app:builder-tract-p
                  (40ants-lake/app:app "foo" :builder t)
                  dir)))
           (testing "A build.lisp in the project root keeps backward compatibility"
             (with-open-file (s (merge-pathnames "build.lisp" dir) :direction :output))
             (ok (40ants-lake/app:builder-tract-p
                  (40ants-lake/app:app "foo")
                  dir))))
      (uiop:delete-directory-tree dir :validate t :if-does-not-exist :ignore))))
