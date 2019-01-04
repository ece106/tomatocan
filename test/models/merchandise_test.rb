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

    #Test Uploaders && Downloaders
    test "show me the full filepath of pdf" do
      merchandise = merchandises(:one)
      puts "\n\n merchpdf = #{merchandise.merchpdf.file.path}\n\n"
    end
    test "show me the full filepath of mobi" do
      merchandise = merchandises(:two)
      puts "\n\n merchmobi = #{merchandise.merchmobi.file.path}\n\n"
    end
    test "show me the full filepath of epub" do
      merchandise = merchandises(:five)
      puts "\n\n merchepub = #{merchandise.merchepub.file.path}\n\n"
    end
    test "show me the full filepath of graphic" do
      merchandise = merchandises(:three)
      puts "\n\n graphic = #{merchandise.graphic.file.path}\n\n"
    end
    test "show me the full filepath of video" do
      merchandise = merchandises(:four)
      puts "\n\n video = #{merchandise.video.file.path}\n\n"
    end
    test "show me the full filepath of audio" do
      merchandise = merchandises(:six)
      puts "\n\n audio = #{merchandise.audio.file.path}\n\n"
    end
end
