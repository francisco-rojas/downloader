# frozen_string_literal: true

require_relative 'image_downloader'

##
# Reads the urls from the source file
class FileProcessor
  attr_reader :source_file, :destination_folder

  def initialize(source_file, destination_folder)
    raise Errno::ENOENT, source_file unless Pathname.new(source_file).file?
    raise Errno::ENOENT, destination_folder unless Pathname.new(destination_folder).directory?

    @source_file = source_file
    @destination_folder = destination_folder
  end

  def process
    # TODO: use sidekiq to retrieve images in background jobs or threads to perform parallel requests
    File.foreach(source_file) do |line|
      begin
        ImageDownloader.new(line.chomp, destination_folder).download
      rescue => e
        puts "#{line} failed with #{e.message}"
        next
      end
    end
  end

  def process!
    File.foreach(source_file) do |line|
      ImageDownloader.new(line, destination_folder).download
    end
  end
end
