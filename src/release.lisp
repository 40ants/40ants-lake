(uiop:define-package #:40ants-lake/release
  (:use #:cl)
  (:import-from #:serapeum
                #:->)  (:import-from #:40ants-lake/app
                #:app
                #:app-release-paths
                #:app-extra-revisions)
  (:export #:make-staging))
(in-package #:40ants-lake/release)


(-> git-revision (pathname &optional (or null string)) (values string &optional))
(defun git-revision (root &optional subpath)
  "Return the trimmed HEAD revision of the git repository at ROOT/SUBPATH."
  (let ((dir (if subpath
                 (merge-pathnames subpath root)
                 root)))
    (uiop:run-program (list "git" "-C" (uiop:native-namestring dir)
                            "rev-parse" "HEAD")
                      :output '(:string :stripped t))))


(-> copy-directory (pathname pathname) (values null &optional))
(defun copy-directory (src dst)
  "Copy directory SRC into DST recursively, creating DST when absent."
  (let ((dst (uiop:ensure-directory-pathname dst)))
    (ensure-directories-exist dst)
    (dolist (file (uiop:directory-files src))
      (uiop:copy-file file (merge-pathnames (file-namestring file) dst)))
    (dolist (subdir (uiop:subdirectories src))
      (let ((name (first (last (pathname-directory subdir)))))
        (copy-directory subdir (merge-pathnames (format nil "~A/" name) dst))))))


(-> copy-to-staging (pathname pathname cons) (values (or null pathname) &optional))
(defun copy-to-staging (staging root pair)
  "Copy one (staging-path . source-path) pair from ROOT into STAGING."
  (let ((src (merge-pathnames (cdr pair) root))
        (dst (merge-pathnames (car pair) staging)))
    (if (uiop:directory-pathname-p src)
        (copy-directory src dst)
        (progn
          (ensure-directories-exist (make-pathname :directory (pathname-directory dst)))
          (uiop:copy-file src dst)))))


(-> write-revision-file (pathname string string) (values string &optional))
(defun write-revision-file (staging filename revision)
  "Write REVISION into STAGING/FILENAME followed by a newline."
  (with-open-file (out (merge-pathnames filename staging)
                       :direction :output
                       :if-exists :supersede)
    (write-line revision out)))


(-> make-staging (app pathname) (values pathname &optional))
(-> %make-staging-directory () (values pathname &optional))
(defun %make-staging-directory ()
  "Atomically create a unique staging directory under the temporary directory.

Uses `mktemp -d` so the name is unique across processes: `gensym` is only
unique within a single Lisp image, and two concurrent deployments with the
same counter would otherwise share (and could delete) one payload."
  (uiop:ensure-directory-pathname
   (pathname
    (uiop:run-program
     (list "mktemp" "-d"
           (namestring (merge-pathnames "staging-XXXXXX"
                                        (uiop:temporary-directory))))
     :output '(:string :stripped t)))))


(defun make-staging (app root)
  "Assemble a temporary staging directory for a release of APP.

The staging directory is created atomically and is unique across processes;
concurrent deployments cannot collide or reuse a failed attempt's directory.

Each element of APP-RELEASE-PATHS is a (staging-path . source-path) pair:
directories are copied recursively, files create their parent directories.
REVISION receives `git rev-parse HEAD` of ROOT; each element of
APP-EXTRA-REVISIONS, a (filename . git-path) pair, receives `git rev-parse
HEAD` of the nested repository at ROOT/git-path.

The caller is responsible for removing the returned directory after the
release has been installed."
  (let ((staging (%make-staging-directory)))
    (dolist (pair (app-release-paths app))
      (copy-to-staging staging root pair))
    (write-revision-file staging "REVISION" (git-revision root))
    (dolist (pair (app-extra-revisions app))
      (write-revision-file staging (car pair) (git-revision root (cdr pair))))
    staging))
