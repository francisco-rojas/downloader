# frozen_string_literal: true

require 'pathname'
require 'net/http'

##
# Base class for downloaders
class Downloader
  SUCCESS_CODES = [200].freeze

  attr_reader :url, :uri, :destination_directory

  def initialize(url, destination_directory)
    @url = url
    @uri = URI(url)
    @destination_directory = destination_directory

    raise "invalid url #{url}" unless valid_url?
  end

  def download
    perform_request

    File.open("#{destination_directory}/#{resource_name}", 'w') do |f|
      f.write(response.read_body)
    end
  end

  def perform_request
    raise NotImplementedError
  end

  def response
    raise NotImplementedError
  end

  private

  def valid_url?
    uri.is_a?(URI::HTTP)
  end
end
