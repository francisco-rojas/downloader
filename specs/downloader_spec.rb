# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/downloader'

describe Downloader do
  it 'receives a filepath on initialization' do
    _ { Downloader.new }.must_raise ArgumentError
  end

  it 'sets the filepath on initialization' do
    filepath = 'path/to/file.txt'

    _(Downloader.new(filepath).filepath).must_equal filepath
  end
end
