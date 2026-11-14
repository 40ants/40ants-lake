(uiop:define-package #:40ants-lake/app
  (:use #:cl)
  (:import-from #:lake)
  (:import-from #:40ants-lake/installation
                #:collect-installation-steps)
  (:import-from #:serapeum
                #:->
                #:defvar-unbound)
  (:export #:app
           #:build-app
           #:defapps
           #:app-name
           #:app-components
           #:app-target-host
           #:app-revisions-to-keep
           #:app-release-paths
           #:app-extra-revisions
           #:app-lisp
           #:app-builder
           #:app-health-check-url
           #:release-build-command
           #:delete-stale-artifact
           #:bin-ready-p
           #:builder-tract-p
           #:uses-build-lisp-p
           #:legacy-build-command
           #:current-app))
(in-package #:40ants-lake/app)


(defvar *apps* nil
  "Apps defined with defapps will be placed here.")


(defvar-unbound *current-app*
  "Will be bound during the call to COLLECT-INSTALLATION-STEPS generic-function.")


(defclass app ()
  ((name :initarg :name
         :type string
         :reader app-name)
   (components :initarg :components
               :type list
               :reader app-components)
   (target-host :initarg :target-host
                :type (or null string)
                :initform nil
                :reader app-target-host)
   (revisions-to-keep :initarg :revisions-to-keep
                      :type integer
                      :initform 3
                      :reader app-revisions-to-keep)
   (release-paths :initarg :release-paths
                  :type list
                  :initform '(("bin" . "bin/"))
                  :reader app-release-paths)
   (extra-revisions :initarg :extra-revisions
                    :type list
                    :initform nil
                    :reader app-extra-revisions)
   (lisp :initarg :lisp
         :type (or null string)
         :initform "sbcl-bin"
         :reader app-lisp)
   (builder :initarg :builder
            :type boolean
            :initform nil
            :reader app-builder)
   (health-check-url :initarg :health-check-url
                     :type (or null string)
                     :initform nil
                     :reader app-health-check-url)))


(defun app (name &key components
                   target-host
                   (revisions-to-keep 3)
                   (release-paths '(("bin" . "bin/")))
                   extra-revisions
                   (lisp "sbcl-bin")
                   builder
                   health-check-url)
  (make-instance 'app
                 :name name
                 :components (uiop:ensure-list components)
                 :target-host target-host
                 :revisions-to-keep revisions-to-keep
                 :release-paths release-paths
                 :extra-revisions extra-revisions
                 :lisp lisp
                 :builder builder
                 :health-check-url health-check-url))



(-> release-build-command (app) (values string &optional))
(defun release-build-command (app)
  "Return the command building the release via the 40ants-builder library.

A fresh Roswell process runs in the project's Qlot environment: it
quickloads the builder and calls `(40ants-builder:build :<name>)`,
where the name is the app's name used as the ASDF system designator.
The builder registers the project's local systems, applies the CCL
and ECL workarounds, pins the build identification (the system's ASDF
version plus the git commit) and dumps the binary via Deploy. The
project's build.lisp, which marked this tract before, is not executed
anymore.

The Lisp is passed to Roswell with -L, taken from the LISP slot
(\"sbcl-bin\" by default). Any spec accepted by `ros run -L` works,
for example \"ccl-bin/1.13\" or a pinned \"sbcl-bin/2.5.9\". When the
slot is NIL, no -L argument is given and Roswell picks its default
Lisp.

Roswell forwards everything after -- to the implementation's own
command line, and those flags are implementation specific:
`--non-interactive` exists on SBCL, while CCL rejects it with
\"Unknown option\" and gets only the eval forms. That is safe because
the builder quits the process explicitly both on success and failure."
  (let ((lisp-spec (app-lisp app))
        (evals (format nil
                       "--eval '(ql:quickload :40ants-builder)' --eval '(40ants-builder:build :~A)'"
                       (app-name app))))
    (cond ((null lisp-spec)
           (format nil "qlot exec ros run -- --non-interactive ~A"
                   evals))
          ((uiop:string-prefix-p "ccl" lisp-spec)
           (format nil "qlot exec ros -L ~A run -- ~A"
                   lisp-spec evals))
          (t
           (format nil "qlot exec ros -L ~A run -- --non-interactive ~A"
                   lisp-spec evals)))))


(-> uses-build-lisp-p ((or pathname string null)) (values boolean &optional))
(defun uses-build-lisp-p (root)
  "Return T when ROOT contains a build.lisp.

The file was the marker of the Deploy tract back when lake executed
it directly. It is kept for backward compatibility: projects with
build.lisp still build through the 40ants-builder library, but the
file itself is not executed anymore."
  (not (null (and root
                  (uiop:file-exists-p (merge-pathnames "build.lisp" root))))))


(-> builder-tract-p (app (or pathname string null)) (values boolean &optional))
(defun builder-tract-p (app root)
  "Return T when APP builds through the 40ants-builder library.

T is returned either when the app passes the BUILDER slot or, for
backward compatibility, when ROOT contains a build.lisp. Other apps
keep using the legacy roswell/<name>.ros build."
  (or (app-builder app)
      (uses-build-lisp-p root)))


(-> legacy-build-command (string) (values string &optional))
(defun legacy-build-command (name)
  "Return the legacy build command for projects without build.lisp."
  (format nil "qlot exec ros dynamic-space-size=32gb build roswell/~A.ros" name))


(-> delete-stale-artifact (app) (values boolean &optional))
(defun delete-stale-artifact (app)
  "Delete the previous bin/<name> artifact, if any.

ASDF skips deploy-op when its output file is newer than the inputs, so
without this a build would silently keep the stale binary when nothing
tracked changed — for example right after switching the LISP slot from
one implementation to another."
  (uiop:delete-file-if-exists
   (merge-pathnames (format nil "bin/~A" (app-name app))
                    (uiop:getcwd))))


(-> shared-library-name-p (string) (values boolean &optional))
(defun shared-library-name-p (name)
  "Return T when the file NAME looks like a shared library.

Matches libfoo.so as well as versioned sonames such as libfoo.so.1 and
libfoo.so.1.5.7, which is how Deploy bundles native libraries in bin/."
  (let ((pos (search ".so" name)))
    (and pos
         (let ((rest (subseq name (+ pos 3))))
           (or (zerop (length rest))
               (char= (char rest 0) #\.))))))


(-> bin-ready-p (&optional pathname) (values boolean &optional))
(defun bin-ready-p (&optional (root (uiop:getcwd)))
  "Return T when ROOT/bin holds a build that can be released as-is.

The directory exists and contains at least one file that is not a
shared library. Deploy fills bin/ with the executable plus *.so
libraries, so a bin/ holding only libraries means the executable
artifact is missing and the build has to run. 'lake to-prod' uses this
to deploy the already built binary; 'lake build' keeps rebuilding
unconditionally."
  (let ((bin (merge-pathnames "bin/" root)))
    (and (uiop:directory-exists-p bin)
         (loop for file in (uiop:directory-files bin)
               thereis (not (shared-library-name-p
                             (file-namestring file)))))))


(defgeneric build-app (app)
  (:method ((app app))
    (if (builder-tract-p app (uiop:getcwd))
        (progn
          (delete-stale-artifact app)
          (lake:sh (release-build-command app)))
        (lake:sh (legacy-build-command (app-name app))))))


(defmacro defapps (&body apps)
  `(setf *apps*
         (list ,@apps)))


(defun current-app ()
  (unless (boundp '*current-app*)
    (error "Function CURRENT-APP should be called inside the COLLECT-INSTALLATION-STEPS call."))
  *current-app*)


(defmethod collect-installation-steps ((app app))
  (let ((*current-app* app))
    (loop for component in (app-components app)
          appending (collect-installation-steps component))))
