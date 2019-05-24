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
    assert_not_nil merchandise.errors[:price]
  end
  #### Test written by lamontano for valdation of button and name
  test "merchandise should be valid" do
    assert @merchandise.valid?
  end

  
  test "merchandise name should be present" do
    @merchandise.name = ""
    assert_not @merchandise.valid?
  end
 
  #this test is to validat the presence of a button
  test "checks to see if a button is present" do
    button_merchandise = Merchandise.new
    assert_not button_merchandise.valid?
    puts button_merchandise.errors[:buttontype]
    assert_not_nil button_merchandise.errors[:buttontype]
  end

  ################################################################
   
   #fix this test method lamontano 05/21/19
   test "get youtube to parse youtube for merchandise" do
      @merchandise.youtube = "http://youtube.com/watch?v=/frlviTJc"
      @merchandise.get_youtube_id
      assert_not_equal("http://youtube.com/watch?v=/frlviTJc", @merchandise.youtube)
    end

    #test crop_itempic
    test "crop_itempic method" do
      assert_not @merchandise.crop_itempic.present?
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
