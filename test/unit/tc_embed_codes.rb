require 'test_helper'

class TestEmbedCodes < ActionController::TestCase

  def test_convert_size
    size = EmbedCode.convert_size("A small portion of the screen")
    assert_equal(size[0], "200px")
    assert_equal(size[1], "400px")

    size = EmbedCode.convert_size("A decent portion of the screen")
    assert_equal(size[0], "400px")
    assert_equal(size[1], "800px")

    size = EmbedCode.convert_size("A large portion of the screen")
    assert_equal(size[0], "800px")
    assert_equal(size[1], "1000px")

    size = EmbedCode.convert_size("else test")
    assert_equal(size[0], "500px")
    assert_equal(size[1], "500px")
  end

  def test_convert_border_size
    border_size = EmbedCode.convert_border_size("Thin")
    assert_equal(border_size, "1px")

    border_size = EmbedCode.convert_border_size("Medium")
    assert_equal(border_size, "5px")

    border_size = EmbedCode.convert_border_size("Especially Wide")
    assert_equal(border_size, "10px")
  end

  def test_convert_position
    position = EmbedCode.convert_position("according to where it is placed in the HTML file")
    assert_equal(position, "default")
    
    position = EmbedCode.convert_position("in a corner of the page")
    assert_equal(position, "absolute")

    position = EmbedCode.convert_position("in a corner of the user's screen")
    assert_equal(position, "fixed")

  	assert_raise( "RuntimeError" ) { EmbedCode.convert_position( "Invalid position option" ) }
  end
 
  def test_convert_location_input
    location = EmbedCode.convert_location("The lower left corner")
    assert_equal(location[0], 0)
    assert_equal(location[1], 1)

    location = EmbedCode.convert_location("The upper left corner")
    assert_equal(location[0], 1)
    assert_equal(location[1], 1)

    location = EmbedCode.convert_location("The upper right corner")
    assert_equal(location[0], 1)
    assert_equal(location[1], 0)

    location = EmbedCode.convert_location("The lower right corner")
    assert_equal(location[0], 0)
    assert_equal(location[1], 0)
  end


  #generate( embed_height, embed_width, embed_border, embed_borderColor, embed_borderWidth, embed_position, embed_bottom, embed_right )
  def test_generate
    code1 = EmbedCode.generate( "200px", "400px", "Yes", "\#F00", "5px", "default", 1, 1)
    assert_response :success
    assert_equal( code1, "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=200px width=400px style=\"position: default; border: 5px solid \#F00;\"></iframe>" )

    # Because "position" is default, generate should produce the same output regardless of location values.
    code2 = EmbedCode.generate( "200px", "400px", "Yes", "\#F00", "5px", "default", -2, -2)
    assert_equal( code1, code2 )

    code2 = EmbedCode.generate( "400px", "800px", "Yes", "\#F00", "1px", "absolute", 0, 1)   
    assert_equal( code2, "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=400px width=800px style=\"position: absolute; z-index:99; bottom: 0; right: 1; border: 1px solid \#F00;\"></iframe>" )

    code2 = EmbedCode.generate( "400px", "800px", "no", "\#F00", "1px", "absolute", 0, 1)   
    assert_equal( code2, "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=400px width=800px style=\"position: absolute; z-index:99; bottom: 0; right: 1;\"></iframe>" )
  end

end
