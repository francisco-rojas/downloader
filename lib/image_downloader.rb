# frozen_string_literal: true

require_relative 'downloader'

##
# Downloads the images from the url provided into the destination_directory
class ImageDownloader < Downloader
  VALID_MIME_TYPE = {
    'image/gif' => '.gif',
    'image/png' => '.png',
    'image/jpeg' => '.jpeg',
    'image/bmp' => '.bmp',
    'image/webp' => '.webb'
  }.freeze

  def response
    @response
  end

  def perform_request
    @response = Net::HTTP.get_response(uri)

    raise 'server responded with error' unless SUCCESS_CODES.include?(response.code.to_i)
    raise 'invalid resource type' unless VALID_MIME_TYPE.keys.include?(response.content_type)
  end

  def resource_name
    return uri.hostname if ['', '/'].include?(uri.path)
    return uri.path.split('/').last if uri.path.split('/').last.include?('.')

    uri.path.split('/').last + VALID_MIME_TYPE[response.content_type]
  end
end
