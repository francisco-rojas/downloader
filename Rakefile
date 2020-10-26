# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['specs/*_spec.rb']
  t.verbose = true
end

# rake download["path/to/source_file.txt","path/to/destination/folder/"]
desc 'Downloads the images from the urls in the file provided'
task :download, [:source_file, :destination_folder] do |_t, args|
  puts args.source_file
  puts args.destination_folder
end
