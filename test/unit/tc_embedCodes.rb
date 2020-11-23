require "test_helper"

class TestEmbedCode < ActionController::TestCase

  def test_convert_input
    session[:embed_height] = "200px"
    session[:embed_width] = "400px"
    assert true
  end

  def test_generate
    assert true
  end 

end
