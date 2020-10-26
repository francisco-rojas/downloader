# frozen_string_literal: true

require 'pathname'
require_relative 'spec_helper'
require 'digest'
require_relative '../lib/downloader'

describe Downloader do
  let(:url) { 'http://www.example.com/images/sample1' }
  let(:fixture_img_path) { fixture_file('sample1.png') }
  let(:source_file_path) { fixture_file('urls.txt') }
  let(:output_file_path) { output_file('sample1.png') }

  before do
    stub_request(:get, url)
      .to_return(
        status: 200,
        headers: { 'Content-Type' => 'image/png' },
        body: File.open(fixture_img_path).read
      )
  end

  it 'receives a filepath on initialization' do
    _ { Downloader.new }.must_raise ArgumentError
  end

  it 'sets the filepath on initialization' do
    _(Downloader.new(source_file_path, output_directory).source_file).must_equal source_file_path
  end

  it 'raises an error if source file does not exist' do
    _ { Downloader.new('path/to/file.txt', output_directory) }.must_raise Errno::ENOENT
  end

  it 'raises an error if destination folder does not exist' do
    _ { Downloader.new(source_file_path, 'non-existing/folder') }.must_raise Errno::ENOENT
  end

  describe 'download' do
    describe 'valid' do
      before do
        Downloader.new(source_file_path, output_directory).download(url)
      end

      it 'downloads the image from a valid url and MIME type' do
        _(Pathname.new(output_file_path).file?).must_equal true
      end

      it 'creates a file with same content of the response' do
        source_digest = Digest::SHA256.hexdigest(File.read(fixture_img_path))
        output_digest = Digest::SHA256.hexdigest(File.read(output_file_path))

        _(output_digest).must_equal source_digest
      end
    end

    describe 'invalid' do
      let(:url) { 'http://www.example.com/files/text1' }
      let(:output_file_path) { output_file('text1') }

      before do
        stub_request(:get, url)
          .to_return(
            status: 200,
            headers: { 'Content-Type' => 'text/plain' },
            body: 'some text'
          )

        Downloader.new(source_file_path, output_directory).download(url)
      end

      it 'does not download a file if the MIME type does not correspond to an image' do
        _(Pathname.new(output_file_path).file?).must_equal false
      end
    end
  end
end
