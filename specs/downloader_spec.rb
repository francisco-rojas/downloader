# frozen_string_literal: true

require 'pathname'
require 'digest'
require_relative 'spec_helper'

describe Downloader do
  let(:url) { 'http://www.example.com/images/sample1' }
  let(:fixture_img_path) { fixture_file('sample1.png') }
  let(:output_file_path) { output_file('sample1.png') }
  let(:downloader) { Downloader.new(url) }

  it 'sets the url on initialization' do
    _(downloader.url).must_equal url
  end

  it 'sets the uri on initialization' do
    _(downloader.uri).must_equal URI(url)
  end

  it 'raises an error when invalid URL provided' do
    _ { Downloader.new('') }.must_raise StandardError
  end

  describe 'when resource is located in root path' do
    let(:url) { 'http://www.example.com/' }

    it 'sets the name of the file to the hostname' do
      _(downloader.resource_name).must_equal 'www.example.com'
    end
  end

  describe 'when resource has a path but no file extension' do
    let(:url) { 'http://www.example.com/images/sample1' }

    it 'sets the name of the file to the last part of the path with the right MIME extension' do
      downloader.stub(:response, OpenStruct.new(content_type: 'image/png')) do
        _(downloader.resource_name).must_equal 'sample1.png'
      end
    end
  end

  describe 'when resource has a path and includes file extension' do
    let(:url) { 'http://www.example.com/images/sample1.png' }

    it 'sets the name of the file to the last part of the path' do
      _(downloader.resource_name).must_equal 'sample1.png'
    end
  end
end
