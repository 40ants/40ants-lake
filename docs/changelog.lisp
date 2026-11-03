(uiop:define-package #:40ants-lake-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:40ants-lake-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "HTTP"))
  (0.3.1 2026-11-04
         "* Added `lisp` app slot (default `sbcl-bin`): the Roswell `-L` spec used by `lake build` and `lake to-prod`; any spec accepted by `ros run -L` works, e.g. `ccl-bin/1.13` or a pinned `sbcl-bin/2.5.9`. The `sbcl-pin` slot was removed — pass its value as `:lisp`.
         * `lake to-prod` invokes the `install-release` helper from the 40ants-lake checkout instead of a host-wide copy in `/usr/local/sbin`; the copy and the sudoers rule are no longer needed.
         * `lake build` and `lake to-prod` no longer pass `--non-interactive` when building with CCL: the flag is SBCL specific and CCL rejects it with `Unknown option`; CCL builds rely on build.lisp quitting the process explicitly.
         * `lake build` deletes the previous `bin/<name>` artifact before building: ASDF skips deploy-op when its output is newer than the inputs, which silently kept the stale binary after switching the `lisp` slot from one implementation to another.")
  (0.3.0 2026-10-27
         "* Added deploy slots to `app`: `target-host`, `revisions-to-keep`, `release-paths`, `extra-revisions`, `sbcl-pin`, `health-check-url`.
          * `lake build` builds via the project's `build.lisp` when present, otherwise falls back to the legacy `roswell/<name>.ros` build.
          * Added release staging assembly; staging directories are created atomically and unique across processes (mktemp -d).
          * `lake to-prod` installs releases via the `/usr/local/sbin/install-release` helper into `/srv/services/<name>/releases/` with atomic `current` flip, retention and a health check; legacy roswell copying remains for projects without `build.lisp`.")
  (0.2.0 2026-02-02
         "* Added command dbdump-schema.")
  (0.1.0 2024-09-02
         "* Initial version."))
