require 'rubygems'
require './google_searcher'
require './image_generator'
require "sinatra"
require "ruby-web-search"
require "fastimage_resize"


set :max_photos_number, 5
set :descriptions, ['or that..', 'or maybe this..', 'that is also possible..', 'that is cool!!', "that is beautiful!"]
set :major_desc, "In some years, probably your current love will look like that.."

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
  if Dir.glob('public/images/{women*}').empty?
    @index = 0
    links_array = @google_searcher.search
    links_array.each_with_index do |link, index|
      @image_generator.generate(link, index)
    end
  end
  @woman_id = rand(0..19)
  @desc = settings.major_desc
  erb :results
end

get '/results/:index' do
  @index = params[:index]
  @max_photos_number = true if @index.to_i >= settings.max_photos_number
  @woman_id = rand(0..19)
  if @index.to_i == 0
    @desc = settings.major_desc
  else
    @desc = settings.descriptions[rand(0..4)]
  end
  erb :results
end

get '/end' do
  erb :end
end

not_found do
  status 404
  'not found'
end