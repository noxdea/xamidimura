# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/*_test.rb"
end

task :rbs do
  sh "bundle exec rbs -I sig validate"
end

task default: :test
