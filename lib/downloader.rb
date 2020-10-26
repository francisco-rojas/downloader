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
    'image/webp' => '.webb'
  }.freeze

  SUCCESS_CODES = [200].freeze

  attr_reader :url, :uri

  def initialize(url)
    @url = url
    @uri = URI(url)

    raise "invalid url #{url}" unless valid_url?
  end

  def download
    raise NotImplementedError
    # perform_request

    # File.open("#{destination_folder}/#{resource_name(line)}", 'w') do |f|
    #   f.write(response.read_body)
    # end
  end

  def response
    raise NotImplementedError
  end

  def resource_name
    return uri.hostname if ['', '/'].include?(uri.path)
    return uri.path.split('/').last if uri.path.split('/').last.include?('.')

    uri.path.split('/').last + VALID_MIME_TYPE[response.content_type]
  end

  private

  # # TODO: handle timeout & HTTP errors
  # def perform_request
  #   response = Net::HTTP.get_response(uri)

  #   raise Net::HTTPError, 'unsuccessful request' if SUCCESS_CODES.include?(response.code)
  #   raise '' if VALID_MIME_TYPE.keys.include?(response.content_type)
  # end

  def valid_url?
    uri.is_a?(URI::HTTP)
  end
end
