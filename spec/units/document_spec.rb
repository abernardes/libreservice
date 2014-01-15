require './lib/libreservice/document'

describe Libreservice::Document do
  let(:filename) { "document.docx" }
  let(:file) { File.open("spec/fixtures/document.docx") }
  let(:converter) { double(:converter, convert: "tmp/document.docx.pdf") }
  let(:downloadable_document) { double(:downloadable_document).as_null_object }

  subject do
    Libreservice::Document.new({ filename: filename, tempfile: file }, {
      converter: converter,
      downloadable_document: downloadable_document,
    })
  end

  before do
    SecureRandom.stub(uuid: '1234')
    FileUtils.cp "spec/fixtures/document.docx.pdf", "tmp/"
  end

  after do
    file.close
  end

  it "converts documents" do
    converter.should_receive(:convert).with("tmp/document.docx")

    subject.convert_to_pdf
  end

  it "creates a tempfile with the file contents" do
    subject.convert_to_pdf

    expect(File.exists?("tmp/document.docx")).to be_true
  end

  it "returns a downloadable document" do
    document = subject.convert_to_pdf

    expect(document).to respond_to :resource_path
  end
end

describe Libreservice::DownloadableDocument do
  describe "resource_path" do
    it "returns the resource path, accessible through a URL" do
      SecureRandom.stub(:uuid => "1234")
      FileUtils.copy "spec/fixtures/document.docx.pdf", "tmp/"

      downloadable_document = Libreservice::DownloadableDocument.new("tmp/document.docx.pdf")

      expect(downloadable_document.resource_path).to eq "1234/document.docx.pdf"
    end
  end
end
