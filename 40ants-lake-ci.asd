(defsystem "40ants-lake-ci"
  :author "Artemenko Alexander <svetlyak.40wt@gmail.com>"
  :license "Unlicense"
  :homepage "https://40ants.com/40ants-lake/"
  :class :package-inferred-system
  :description "Provides CI settings for 40ants-lake."
  :source-control (:git "https://github.com/40ants/40ants-lake")
  :bug-tracker "https://github.com/40ants/40ants-lake/issues"
  :pathname "src"
  :depends-on ("40ants-ci"
               "40ants-lake-ci/ci"))
