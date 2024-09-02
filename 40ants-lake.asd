#-asdf3.1 (error "40ants-lake requires ASDF 3.1 because for lower versions pathname does not work for package-inferred systems.")
(defsystem "40ants-lake"
  :description "Common Lake commands for 40Ants projects."
  :author "Artemenko Alexander <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/40ants-lake/"
  :source-control (:git "https://github.com/40ants/40ants-lake")
  :bug-tracker "https://github.com/40ants/40ants-lake/issues"
  :class :40ants-asdf-system
  :defsystem-depends-on ("40ants-asdf-system")
  :pathname "src"
  :depends-on ("40ants-lake/core"
               "40ants-lake/commands/install"
               "40ants-lake/commands/help"
               "40ants-lake/utils"
               ;; I have to find a way to load lparallel before lake
               ;; otherwise it breaks when lake's fasl files are loaded before lparallel.
               ;; 
               ;; To make Lake execute tasks in parallel when it is possible:
               ;; "lparallel"
               )
  :in-order-to ((test-op (test-op "40ants-lake-tests"))))
