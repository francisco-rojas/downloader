# frozen_string_literal: true

require_relative 'spec_helper'

describe FileProcessor do
  let(:source_file_path) { fixture_file('urls.txt') }
  let(:output_folder) { output_directory }

  it 'receives a filepath on initialization' do
    _ { FileProcessor.new }.must_raise ArgumentError
  end

  it 'sets the filepath on initialization' do
    _(FileProcessor.new(source_file_path, output_directory).source_file).must_equal source_file_path
  end

  it 'raises an error if source file does not exist' do
    _ { FileProcessor.new('path/to/file.txt', output_directory) }.must_raise Errno::ENOENT
  end

  it 'raises an error if destination folder does not exist' do
    _ { FileProcessor.new(source_file_path, 'non-existing/folder') }.must_raise Errno::ENOENT
  end
end
