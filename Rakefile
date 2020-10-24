# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['specs/*_spec.rb']
  t.verbose = true
end

# rake download["path/to/file"]
desc 'Downloads the images from the urls in the file provided'
task :download, [:filepath] do |_t, args|
  puts args.filepath
end
