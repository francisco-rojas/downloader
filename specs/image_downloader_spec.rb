# frozen_string_literal: true

require_relative 'spec_helper'

describe ImageDownloader do
  let(:url) { 'http://www.example.com/images/sample1' }
  let(:fixture_img_path) { fixture_file('sample1.png') }
  let(:output_file_path) { output_file('sample1.png') }
  let(:downloader) { ImageDownloader.new(url, output_directory) }

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

  describe 'file download' do
    describe 'success' do
      before do
        stub_request(:get, url)
          .to_return(
            status: 200,
            headers: { 'Content-Type' => 'image/png' },
            body: File.open(fixture_img_path).read
          )

        downloader.download
      end

      it 'downloads a valid image' do
        _(Pathname.new(output_file_path).file?).must_equal true
      end

      it 'creates a file with same content of the response' do
        source_digest = Digest::SHA256.hexdigest(File.read(fixture_img_path))
        output_digest = Digest::SHA256.hexdigest(File.read(output_file_path))

        _(output_digest).must_equal source_digest
      end
    end
  end

  describe 'wrong MIME type' do
    before do
      stub_request(:get, url)
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'text/html' },
          body: '<h1>hello world!</h1>'
        )
    end

    it 'raises an error' do
      _ { downloader.download }.must_raise StandardError
    end
  end

  describe 'wrong server response code' do
    before do
      stub_request(:get, url)
        .to_return(
          status: 404,
          headers: { 'Content-Type' => 'image/png' },
          body: ''
        )
    end

    it 'raises an error' do
      _ { downloader.download }.must_raise StandardError
    end
  end
end
