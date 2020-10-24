# frozen_string_literal: true

##
# Downloads the images from the urls provided in the file
class Downloader
  attr_reader :filepath

  def initialize(filepath)
    @filepath = filepath
  end

  private

  def file_content; end
end
