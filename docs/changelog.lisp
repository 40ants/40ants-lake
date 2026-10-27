(uiop:define-package #:40ants-lake-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:40ants-lake-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "HTTP"))
  (0.3.0 2026-10-27
         "* Added deploy slots to `app`: `target-host`, `revisions-to-keep`, `release-paths`, `extra-revisions`, `sbcl-pin`, `health-check-url`.
          * `lake build` builds via the project's `build.lisp` when present, otherwise falls back to the legacy `roswell/<name>.ros` build.
          * Added release staging assembly.
          * `lake to-prod` installs releases via the `/usr/local/sbin/install-release` helper into `/srv/services/<name>/releases/` with atomic `current` flip, retention and a health check; legacy roswell copying remains for projects without `build.lisp`.")
  (0.2.0 2026-02-02
         "* Added command dbdump-schema.")
  (0.1.0 2024-09-02
         "* Initial version."))
