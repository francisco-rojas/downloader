# frozen_string_literal: true

require 'pathname'
require_relative 'spec_helper'
require_relative '../lib/downloader'

describe Downloader do
  before do
    stub_request(:get, 'www.example.com/images/1').
      to_return(
        status: 200,
        headers: { 'Content-Type' => 'image/png' },
        body: File.open(fixture_file("sample1.png")).read
      )
  end

  it 'receives a filepath on initialization' do
    _ { Downloader.new }.must_raise ArgumentError
  end

  it 'sets the filepath on initialization' do
    filepath = fixture_file('urls.txt')
    _(Downloader.new(filepath, output_directory).source_file).must_equal filepath
  end

  it 'raises an error if source file does not exist' do
    _ { Downloader.new('path/to/file.txt', output_directory) }.must_raise Errno::ENOENT
  end

  it 'raises an error if destination folder does not exist' do
    _ { Downloader.new(fixture_file('urls.txt'), 'non-existing/folder') }.must_raise Errno::ENOENT
  end

  it 'downloads the image from a valid url' do
    downloader = Downloader.new(fixture_file('urls.txt'), output_directory)
    downloader.download('http://www.example.com/images/1')
    _(Pathname.new(output_file("1.png")).file?).must_equal true
  end
end
