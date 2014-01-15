require_relative 'document_converter'

module Libreservice
  class DownloadableDocument

    def initialize(tempfile)
      @tempfile = tempfile
      @uuid = SecureRandom.uuid
      make_downloadable
    end

    def resource_path
      "#{uuid}/#{filename}"
    end

    private

    attr_reader :uuid

    def make_downloadable
      FileUtils.move @tempfile, public_dir
    end

    def filename
      @tempfile.split("/").last
    end

    def public_dir
      Dir.mkdir(public_path, 0700) unless Dir.exists?(public_path)

      public_path
    end

    def public_path
      "public/#{uuid}/"
    end
  end

  class Document
    attr_reader :file

    def initialize(file_param, options={})
      @file_param = file_param
      @converter = options[:converter] || DocumentConverter
      @downloadable_document = options[:downloadable_document]
    end

    def convert_to_pdf
      create_tempfile
      downloadable_document(@converter.convert(filename))
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

    def downloadable_document(converted_file)
      DownloadableDocument.new(converted_file)
    end
  end
end
