require 'rubygems'
require './google_searcher'
require './image_generator'
require "sinatra"
require "ruby-web-search"
require "fastimage_resize"


set :max_photos_number, 4

before do
  @google_searcher = GoogleSearcher.new
  @image_generator = ImageGenerator.new
end

get '/' do  
  erb :index
end  

get '/form' do
  erb :form
end

post '/results' do
  if @index.nil?
    @index = 0
    links_array = @google_searcher.search
    links_array.each_with_index do |link, index| 
      @image_generator.generate(link, index);
    end
  end
  erb :results
end

get '/results/:index' do
  @index = params[:index]
  @max_photos_number = true if @index.to_i >= settings.max_photos_number
  erb :results
end

get '/end' do
  erb :end
end

not_found do
  status 404
  'not found'
end