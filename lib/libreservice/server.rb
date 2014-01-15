require 'libreconv'
require 'json'
require 'sinatra/base'
require_relative 'document'


module Libreservice
  class Server < Sinatra::Base
    set :bind, '0.0.0.0'

    post '/convert' do
      content_type :json

      document = Document.new(params['file']).convert_to_pdf

      {
        conversion_status: "OK",
        document_url: [request.base_url, document.resource_path].join("/"),
      }.to_json
    end
  end
end
