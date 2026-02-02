(uiop:define-package #:40ants-lake-docs/changelog
  (:use #:cl)
  (:import-from #:40ants-doc/changelog
                #:defchangelog))
(in-package #:40ants-lake-docs/changelog)


(defchangelog (:ignore-words ("SLY"
                              "ASDF"
                              "REPL"
                              "HTTP"))
  (0.2.0 2026-02-02
         "* Added command dbdump-schema.")
  (0.1.0 2024-09-02
         "* Initial version."))
