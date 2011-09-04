require 'sinatra/base'
require 'json'
require 'face'

class App < Sinatra::Base
  get '/' do
    count = face_count(params[:src])

    {
      :src   => params[:src],
      :count => count
    }.to_json
  end

  helpers do
    def face_count(src)
      face_data = client.faces_detect(:urls => [src], :attributes => 'none')

      face_data['photos'].first['tags'].size
    end

    def client
      @client ||= Face.get_client(
        :api_key    => (ENV['FACE_API_KEY']     || raise("Missing FACE_API_KEY.")),
        :api_secret => (ENV['FACE_API_SECRET']  || raise("Missing FACE_API_SECRET.")))
    end
  end
end

run App
