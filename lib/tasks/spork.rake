desc "run all tests with spork"
task :spork do
  exec 'find test -path "test/performance" -prune -o -name "*_test.rb" -print | xargs testdrb -Itest'
end