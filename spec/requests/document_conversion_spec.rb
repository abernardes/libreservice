ENV['RACK_ENV'] = 'test'

require 'pry'
require 'rspec'
require 'rack/test'
require './lib/libreservice/server'

describe "Requesting a document conversion" do
  include Rack::Test::Methods

  def app
    Libreservice::Server
  end

  let(:filename) { "spec/fixtures/document.docx" }
  let(:mime_type) { "application/vnd.openxmlformats-officedocument.wordprocessingml.document" }

  before do
    Libreconv.stub(:convert)
    SecureRandom.stub(:uuid => "1234")
  end

  after do
    FileUtils.rm_r Dir.glob('tmp/*')
  end

  context "POST /convert" do
    let(:file) { Rack::Test::UploadedFile.new(filename, mime_type) }

    it "converts a given file to the PDF format." do
      FileUtils.copy "spec/fixtures/document.docx.pdf", "tmp/"
      post "/convert", :file => file

      expect(last_response.body).to eq({ conversion_status: "OK", document_url: "http://example.org/1234/document.docx.pdf" }.to_json)
    end

    it "raises an error if conversion failed" do
      expect {
        post "/convert", :file => file
      }.to raise_error(Libreservice::FailedConversionError)
    end
  end
end
