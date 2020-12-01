require 'test_helper'

class TestEmbedCodes < ActionController::TestCase

  def test_convert_size
    size = EmbedCode.convert_size("A small portion of the screen")
    assert_equal(size[0], "200px")
    assert_equal(size[1], "400px")

    
  end

  def test_convert_border_size
  	# Note to Vaughn: You don't need to test every input combination. But you *should* try to test at least most of the different types of input for each option.
  end

  def test_convert_position
  	
  	
  	assert_raise( "RuntimeError" ) { EmbedCode.convert_position( "Invalid position option" ) }
  end
 
  def test_convert_location_input
  	
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
    # Note to Vaughn: You could use other methods of expressing colors (e.g. colorname, #RRGGBB, rgba(), etc.) in other test cases
  end

end
