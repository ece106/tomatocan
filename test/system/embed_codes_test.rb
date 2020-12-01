require "application_system_test_case"

class EmbedCodesTest < ApplicationSystemTestCase
  setup do
    @embed_code = embed_codes(:one)
  end

  test "visiting the index" do
    visit embed_codes_url
    assert_selector "h1", text: "Embed codes"
  end

  test "creating a Embed code" do
    visit embed_codes_url
    click_on "New Embed code"

    fill_in "Border", with: @embed_code.border
    fill_in "Border color", with: @embed_code.border_color
    fill_in "Border size", with: @embed_code.border_size
    fill_in "Location", with: @embed_code.location
    fill_in "Size", with: @embed_code.size
    fill_in "Special position", with: @embed_code.special_position
    click_on "Create Embed code"

    assert_text "Embed code was successfully created"
    click_on "Back"
  end

  test "updating a Embed code" do
    visit embed_codes_url
    click_on "Edit", match: :first

    fill_in "Border", with: @embed_code.border
    fill_in "Border color", with: @embed_code.border_color
    fill_in "Border size", with: @embed_code.border_size
    fill_in "Location", with: @embed_code.location
    fill_in "Size", with: @embed_code.size
    fill_in "Special position", with: @embed_code.special_position
    click_on "Update Embed code"

    assert_text "Embed code was successfully updated"
    click_on "Back"
  end

  test "destroying a Embed code" do
    visit embed_codes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Embed code was successfully destroyed"
  end
end
