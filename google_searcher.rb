class GoogleSearcher
    def search
      response = RubyWebSearch::Google.search(:query => "old women", :type => :image)
      links_array = Array.new
      response.results.each { |result| links_array << result[:url] }
      links_array
    end    
  end
