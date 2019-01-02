require 'test_helper'

class MerchandiseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
   def setup
    @merchandise = merchandises(:one)
  end

  test "price should not be empty" do
    merchandise = Merchandise.new
    merchandise.send "price=",nil
    refute merchandise.valid?
    refute_empty merchandise.errors[:price]
  end

   test "parse youtube for merchanise" do
      @merchandise.youtube = "http://youtube.com/watch?v=/frlviTJc"
      @merchandise.get_youtube_id
      refute_equal("http://youtube.com/watch?v=/frlviTJc", @merchandise.youtube)
    end

    # test "show me the full filepath of my pdf" do
    #   merchandise = merchandises(:one)
    #   puts "\n\n#{merchandise.merchpdf.file.path}\n\n"
    # end
    test "show me the full filepath of my mobi" do
      merchandise = merchandises(:two)
      puts "\n\n#{merchandise.merchmobi.file.path}\n\n"
    end


end
