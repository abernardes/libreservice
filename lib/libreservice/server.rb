require 'libreconv'
require 'sinatra/base'
require_relative 'document'


module Libreservice
  class Server < Sinatra::Base
    set :bind, '0.0.0.0'

    post '/convert' do
      document = Document.new(params['file'])

      attachment document.convert_to_pdf

      "Converted file enclosed"
    end
  end
end

Libreservice::Server.run!
