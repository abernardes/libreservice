module Libreservice
  class FailedConversionError < StandardError; end

  class DocumentConverter
    def initialize(filename, converter = Libreconv)
      @filename = filename
      @converter = converter
    end

    def self.convert(filename)
      new(filename).convert
    end

    def convert
      @converter.convert(filename, "#{filename}.pdf")

      raise FailedConversionError unless File.exist?("#{filename}.pdf")

      "#{filename}.pdf"
    end

    private

    attr_reader :filename, :file
  end
end
