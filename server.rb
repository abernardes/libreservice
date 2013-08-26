require 'libreconv'
require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  "Hello world!"
end

post '/convert' do
  filename = "conversions/#{params["file"][:filename]}"

  File.open(filename, 'w') do |f|
    f.write(params['file'][:tempfile].read)
  end

  Libreconv.convert(filename, "#{filename}.pdf")

  attachment "#{filename}.pdf"
  "Here's your file"
end
