require_relative '../fallout.rb'
require 'rspec'
require 'rspec/mocks'
require 'rspec/mocks/standalone'
require 'rack/test'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

set :environment, :test

def app
  app = Sinatra::Application
end

Capybara.app = app

describe "Falloutlove application" do
	include Capybara::DSL, Rack::Test::Methods

  it "should load index page" do
	  get '/'
	  last_response.should be_ok
  end

  describe "form page" do
  	before { visit '/form' }

    it "should have option with 'Boy' and 'Girl" do
      page.should have_selector('option', text: 'Boy')
      page.should have_selector('option', text: 'Girl')
    end

    it "should have submit button" do
      page.should have_button('Fall out')
    end
  end

  def prepare_mock(gs_clazz, ig_clazz)
      @links_array_mock = ["http://results/0", "http://results/1"]
      
      @google_searcher_mock = mock(gs_clazz)
      gs_clazz.stub(:new).with(any_args()).and_return(@google_searcher_mock)

      @image_generator_mock = mock(ig_clazz)
      @image_generator_mock.stub!(:generate).with(any_args())
      ig_clazz.stub(:new).with(any_args()).and_return(@image_generator_mock)
  end

  def set_expectations
    yield
  end

  describe "results page" do
    before (:each) do 
      prepare_mock(GoogleSearcher, ImageGenerator)
    end

    describe "with two photos" do
      before do
        set_expectations do
          @google_searcher_mock.stub!(:search).with(any_args()).and_return(@links_array_mock)
          @google_searcher_mock.should_receive(:search).and_return(@links_array_mock)
        end

        set_expectations do
          @image_generator_mock.should_receive(:generate).exactly(2).times
        end

        app.set :max_photos_number, 1

        visit '/form'
        click_button('Fall out')
      end

      it "should show results page with 'Next' button" do
        page.should have_link('Next')
      end

      it "should show results page with 'End up' and 'Repeat' button" do
        click_link('Next')

        page.should have_content('End up')
        page.should have_content('Repeat')
      end
    end

    describe "with three photos" do
      before do
        @links_array_mock.push("http://results/2")

        set_expectations do
          @google_searcher_mock.stub!(:search).with(any_args()).and_return(@links_array_mock)
          @google_searcher_mock.should_receive(:search).and_return(@links_array_mock)
        end
        
        set_expectations do
          @image_generator_mock.should_receive(:generate).exactly(3).times
        end

        app.set :max_photos_number, 2

        visit '/form'
        click_button('Fall out')
      end

      it "should show results page with 'Next' button" do
        page.should have_link('Next')
      end

      it "should show results page with 'End up' and 'Repeat' button" do
        click_link('Next')
        click_link('Next')

        page.should have_content('End up')
        page.should have_content('Repeat')
      end
    end
  end
end