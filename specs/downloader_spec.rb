# frozen_string_literal: true

require 'pathname'
require 'digest'
require_relative 'spec_helper'

describe Downloader do
  let(:url) { 'http://www.example.com/images/sample1' }
  let(:downloader) { Downloader.new(url, output_directory) }

  it 'sets the url on initialization' do
    _(downloader.url).must_equal url
  end

  it 'sets the destination_directory on initialization' do
    _(downloader.destination_directory).must_equal output_directory
  end

  it 'sets the uri on initialization' do
    _(downloader.uri).must_equal URI(url)
  end

  it 'raises an error when invalid URL provided' do
    _ { Downloader.new('', output_directory) }.must_raise StandardError
  end
end
