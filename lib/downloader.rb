# frozen_string_literal: true

require 'pathname'
require 'net/http'

##
# Downloads the images from the urls provided in the file
class Downloader
  VALID_MIME_TYPE = {
    'image/gif' => '.gif',
    'image/png' => '.png',
    'image/jpeg' => '.jpeg',
    'image/bmp' => '.bmp',
    'image/webp' => 'webb'
  }.freeze

  SUCCESS_CODES = [200].freeze

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
    perform_request(line)
    return unless SUCCESS_CODES.include?(response.code) &&
                  VALID_MIME_TYPE.keys.include?(response.content_type)

    File.open("#{destination_folder}/#{resource_name(line)}", 'w') do |f|
      f.write(response.read_body)
    end
  end

  private

  attr_reader :response

  # TODO: handle timeout & HTTP errors
  def perform_request(url)
    @response = Net::HTTP.get_response(URI(url))
  end

  def resource_name(line)
    path = URI(line).path.split('/').last
    return path if path.include?('.') # includes extention already

    path + VALID_MIME_TYPE[response.content_type]
  end

  def valid_url?(url)
    URI(url).is_a?(URI::HTTP)
  end
end
