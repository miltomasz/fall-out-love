class ImageGenerator
	def initialize(width = 150, height = 0)
    @width, @height = width, height
    @outfile = "public/images/"
	end

  def outfile=(path)
    @outfile = path
  end

  def generate(link, pic_number)
    FastImage.resize(link, @width, @height, :outfile => @outfile + "women-#{pic_number}.png")
  end
end