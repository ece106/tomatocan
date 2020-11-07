require "application_system_test_case"

class EmbedLinksTest < ApplicationSystemTestCase
  setup do
    @embed_link = embed_links(:one)
  end

  test "visiting the index" do
    visit embed_links_url
    assert_selector "h1", text: "Embed Links"
  end

  test "creating a Embed link" do
    visit embed_links_url
    click_on "New Embed Link"

    check "Border" if @embed_link.border
    fill_in "Border color", with: @embed_link.border_color
    fill_in "Border size", with: @embed_link.border_size
    fill_in "Location", with: @embed_link.location
    fill_in "Size", with: @embed_link.size
    fill_in "Special position", with: @embed_link.special_position
    click_on "Create Embed link"

    assert_text "Embed link was successfully created"
    click_on "Back"
  end

  test "updating a Embed link" do
    visit embed_links_url
    click_on "Edit", match: :first

    check "Border" if @embed_link.border
    fill_in "Border color", with: @embed_link.border_color
    fill_in "Border size", with: @embed_link.border_size
    fill_in "Location", with: @embed_link.location
    fill_in "Size", with: @embed_link.size
    fill_in "Special position", with: @embed_link.special_position
    click_on "Update Embed link"

    assert_text "Embed link was successfully updated"
    click_on "Back"
  end

  test "destroying a Embed link" do
    visit embed_links_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Embed link was successfully destroyed"
  end
end
