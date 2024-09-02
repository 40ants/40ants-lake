(defsystem "40ants-lake-tests"
  :author "Artemenko Alexander <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/40ants-lake/"
  :class :package-inferred-system
  :description "Provides tests for 40ants-lake."
  :source-control (:git "https://github.com/40ants/40ants-lake")
  :bug-tracker "https://github.com/40ants/40ants-lake/issues"
  :pathname "t"
  :depends-on ("40ants-lake-tests/core")
  :perform (test-op (op c)
                    (unless (symbol-call :rove :run c)
                      (error "Tests failed"))))
