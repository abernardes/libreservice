require 'libreconv'
require 'sinatra'
require_relative 'lib/document'

set :bind, '0.0.0.0'

post '/convert' do
  document = Document.new(params['file'])

  attachment document.convert_to_pdf

  "Converted file enclosed"
end
