(defpackage #:40ants-lake-tests/release
  (:use #:cl #:rove)
  (:import-from #:40ants-lake/app
                #:app)
  (:import-from #:40ants-lake/release))
(in-package #:40ants-lake-tests/release)


(defun %git (&rest command)
  (uiop:run-program (list* "git" command)))

(defun %git-in (dir &rest command)
  (uiop:run-program (list* "git" "-C" (uiop:native-namestring dir)
                           command)))

(defun git-head (dir)
  (string-right-trim '(#\Newline #\Return #\Space)
    (uiop:run-program (list "git" "-C" (uiop:native-namestring dir)
                            "rev-parse" "HEAD")
                      :output :string)))

(defun git-init (dir)
  (%git-in dir "init" "-q")
  (%git-in dir "config" "user.email" "test@example.com")
  (%git-in dir "config" "user.name" "Test")
  (%git-in dir "add" "-A")
  (%git-in dir "commit" "-q" "-m" "init"))

(defun make-fixture (root)
  "Create a project fixture: git repo with bin/app, deploy/www/index.html
and a nested git repo libs/sub."
  (ensure-directories-exist (merge-pathnames "bin/" root))
  (ensure-directories-exist (merge-pathnames "deploy/www/" root))
  (ensure-directories-exist (merge-pathnames "libs/sub/" root))
  (with-open-file (s (merge-pathnames "bin/app" root) :direction :output)
    (princ "#!/bin/sh" s))
  (with-open-file (s (merge-pathnames "deploy/www/index.html" root) :direction :output)
    (princ "<html>index</html>" s))
  (with-open-file (s (merge-pathnames "libs/sub/README" root) :direction :output)
    (princ "sub" s))
  ;; The nested repo must be initialized before the outer one commits.
  (git-init (merge-pathnames "libs/sub/" root))
  (git-init root))


(deftest make-staging-layout
  (let* ((root (merge-pathnames (format nil "40ants-lake-release-~A/" (gensym ""))
                                (uiop:temporary-directory)))
         (app (40ants-lake/app:app "pingvito"
                                   :release-paths '(("bin" . "bin/")
                                                    ("public/index.html" . "deploy/www/index.html"))
                                   :extra-revisions '(("MAX_REVISION" . "libs/sub")))))
    (ensure-directories-exist root)
    (make-fixture root)
    (unwind-protect
         (let ((staging (40ants-lake/release:make-staging app root)))
           (ok (uiop:file-exists-p (merge-pathnames "bin/app" staging))
               "bin/app is copied into staging")
           (ok (uiop:file-exists-p (merge-pathnames "public/index.html" staging))
               "landing is copied into staging under public/")
           (ok (string= (git-head root)
                        (string-right-trim '(#\Newline)
                          (uiop:read-file-string (merge-pathnames "REVISION" staging))))
               "REVISION contains the root repo HEAD")
           (ok (string= (git-head (merge-pathnames "libs/sub/" root))
                        (string-right-trim '(#\Newline)
                          (uiop:read-file-string (merge-pathnames "MAX_REVISION" staging))))
               "MAX_REVISION contains the nested repo HEAD")
           (uiop:delete-directory-tree staging :validate t :if-does-not-exist :ignore))
      (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore))))
