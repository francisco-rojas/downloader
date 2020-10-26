# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require 'webmock/minitest'
require 'minitest/pride'
require 'pry'

WebMock.disable_net_connect!

def spec_directory
  __dir__
end

def fixtures_directory
  spec_directory + '/fixtures'
end

def fixture_file(filename)
  "#{fixtures_directory}/#{filename}"
end

def output_directory
  spec_directory + '/output'
end

def output_file(filename)
  "#{output_directory}/#{filename}"
end
