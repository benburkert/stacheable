require 'sinatra/base'
require 'json'
require 'face'

class App < Sinatra::Base
  get '/' do
    {params[:src] => face?(params[:src])}.to_json
  end

  helpers do
    def face?(src)
      face_data = client.faces_detect(:urls => [src], :attributes => 'none')

      !face_data['photos'].first['tags'].empty?
    end

    def client
      @client ||= Face.get_client(
        :api_key    => (ENV['FACE_API_KEY']     || raise("Missing FACE_API_KEY.")),
        :api_secret => (ENV['FACE_API_SECRET']  || raise("Missing FACE_API_SECRET.")))
    end
  end
end

run App
