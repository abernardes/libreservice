require_relative 'document_converter'

module Libreservice
  class Document
    attr_reader :file

    def initialize(file_param, options={})
      @file_param = file_param
      @converter = options[:converter] || DocumentConverter
    end

    def convert_to_pdf
      create_tempfile
      @converter.convert(filename)
    end

    private

    def create_tempfile
      File.open(filename, 'w') do |target_file|
        target_file.write(file.read)
      end
    end

    def filename
      temp_path + @file_param[:filename]
    end

    def temp_path
      "tmp/"
    end

    def file
      @file_param[:tempfile]
    end
  end
end
