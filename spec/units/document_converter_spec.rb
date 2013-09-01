require './lib/document_converter'

describe Libreservice::DocumentConverter do
  describe "#convert" do
    let(:converter) { double(:converter, convert: nil) }

    before do
      FileUtils.copy "spec/fixtures/document.docx.pdf", "tmp/"
    end

    subject { Libreservice::DocumentConverter.new("tmp/document.docx", converter) }

    after do
      FileUtils.rm_r Dir.glob('tmp/*')
    end

    it "converts a given file to PDF using Libreconv" do
      converter.should_receive(:convert).with("tmp/document.docx", "tmp/document.docx.pdf")

      subject.convert
    end

    it "raises an error if conversion fails" do
      FileUtils.rm "tmp/document.docx.pdf"

      expect {
        subject.convert
      }.to raise_error(Libreservice::FailedConversionError)
    end

    it "returns the converted filename" do
      expect(subject.convert).to eq "tmp/document.docx.pdf"
    end
  end
end
