(uiop:define-package #:40ants-lake/commands/default
  (:use #:cl)
  (:import-from #:40ants-lake/utils
                #:alias))
(in-package #:40ants-lake/commands/default)


(alias "default" "help")

