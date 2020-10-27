# frozen_string_literal: true

require_relative 'lib/file_processor'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['specs/*_spec.rb']
  t.verbose = true
end

# rake download["/app/specs/fixtures/urls.txt","/app/specs/output"]
desc 'Downloads the images from the urls in the file provided'
task :download, [:source_file, :destination_folder] do |_t, args|
  puts "Processing file #{args.source_file}"

  FileProcessor.new(args.source_file, args.destination_folder).process

  puts "Done!"
end
