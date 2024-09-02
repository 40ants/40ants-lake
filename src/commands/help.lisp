(uiop:define-package #:40ants-lake/commands/help
  (:use #:cl)
  (:import-from #:lake))
(in-package #:40ants-lake/commands/help)


(lake:task "help" ()
  "Show documentation on commands."
  (lake::%display-tasks lake::*tasks*))
