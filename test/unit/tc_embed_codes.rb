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
    # Note to Vaughn: You don't need totest every input combination. But you *should* try to test at least most of the different types of input for each option.
    border_size = EmbedCode.convert_border_size("Thin")
    assert_equal(border_size, "1px")

    border_size = EmbedCode.convert_border_size("Medium")
    assert_equal(border_size, "5px")

    border_size = EmbedCode.convert_border_size("Especially Wide")
    assert_equal(border_size, "10px")
  end

  def test_convert_position
    position = EmbedCode.convert_position("according to where it is placed in the html file")
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

    location = EmbedCode.convert_location("else test")
    assert_equal(location[0], -1)
    assert_equal(location[1], -1)
  end


  #generate( embed_height, embed_width, embed_border, embed_borderColor, embed_borderWidth, embed_position, embed_bottom, embed_right )
  def test_generate
    code1 = EmbedCode.generate( "200px", "400px", "Yes", "\#F00", "5px", "default", 1, 1)
    assert_response :success
    assert_equal( code1, "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=200px width=400px style=\"position: default; border: 5px solid \#F00;\"></iframe>" )

    # Because "position" is default, generate should produce the same output regardless of location values.
    code2 = EmbedCode.generate( "200px", "400px", "Yes", "\#F00", "5px", "default", -2, -2)
    assert_equal( code1, code2 )

    # Note to Vaughn: Write at least one assertion where default isn't used for position.
    code3 = EmbedCode.generate( "400px", "800px", "Yes", "\#F00", "1px", "absolute", 0, 1)   
    assert_equal( code3, "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=400px width=800px style=\"position: absolute; z-index:99; bottom: 0; right: 1; border: 1px solid \#F00;\"></iframe>" )

    code4 = EmbedCode.generate( "800px", "1000px", "Yes", "\#F00", "10px", "fixed", 1, 1)   
    assert_equal( code4, "<iframe src=\"https://thinq.tv/embed\" title=\"ThinQ.tv: Join in with tech industry tips!\" height=800px width=1000px style=\"position: fixed; z-index:99; bottom: 1; right: 1; border: 10px solid \#F00;\"></iframe>" )
    # Note to Vaughn: You could use other methods of expressing colors (e.g. colorname, #RRGGBB, rgba(), etc.) in other test cases
  end

end
