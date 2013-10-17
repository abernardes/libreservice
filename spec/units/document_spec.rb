require './lib/libreservice/document'

describe Libreservice::Document do
  let(:filename) { "document.docx" }
  let(:file) { File.open("spec/fixtures/document.docx") }
  let(:converter) { double(:converter, convert: "tmp/document.docx.pdf") }

  subject { Libreservice::Document.new({ filename: filename, tempfile: file }, converter: converter) }

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
end
