ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require './lib/server'

describe "Requesting a document conversion" do
  include Rack::Test::Methods

  def app
    Libreservice::Server
  end

  let(:filename) { "spec/fixtures/document.docx" }
  let(:mime_type) { "application/vnd.openxmlformats-officedocument.wordprocessingml.document" }

  before do
    Libreconv.stub(:convert)
  end

  after do
    FileUtils.rm_r Dir.glob('tmp/*')
  end

  context "POST /convert" do
    let(:file) { Rack::Test::UploadedFile.new(filename, mime_type) }

    it "converts a given file to the PDF format." do
      FileUtils.copy "spec/fixtures/document.docx.pdf", "tmp/"
      post "/convert", :file => file

      expect(last_response.header["Content-Disposition"]).to eq 'attachment; filename="document.docx.pdf"'
    end

    it "raises an error if conversion failed" do
      expect {
        post "/convert", :file => file
      }.to raise_error(Libreservice::FailedConversionError)
    end
  end
end
