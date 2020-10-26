# frozen_string_literal: true

require 'pathname'
require 'net/http'

##
# Downloads the images from the urls provided in the file
class Downloader
  attr_reader :source_file, :destination_folder

  def initialize(source_file, destination_folder)
    raise Errno::ENOENT, source_file unless Pathname.new(source_file).file?
    raise Errno::ENOENT, destination_folder unless Pathname.new(destination_folder).directory?

    @source_file = source_file
    @destination_folder = destination_folder
  end

  def process
    File.foreach(source_file) do |line|
      download(line) if valid_url?(line)
    end
  end

  def download(line)
    response = Net::HTTP.get_response(URI(line))

    File.open("#{destination_folder}/#{resource_name(line)}", "w") do |f|
      f.puts response.read_body
    end
  end

  private

    def resource_name(line)
      URI(line).path.split('/').last
    end

    def valid_url?(url)
      URI(url).kind_of?(URI::HTTP)
    end
end
