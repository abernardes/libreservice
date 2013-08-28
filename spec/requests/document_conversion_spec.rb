ENV['RACK_ENV'] = 'test'

require 'pry'
require 'rspec'
require 'rack/test'
require_relative '../../server.rb'

describe "Requesting a document conversion" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
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
      }.to raise_error(FailedConversionError)
    end
  end
end
