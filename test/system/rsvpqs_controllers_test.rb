require "application_system_test_case"

class RsvpqsControllersTest < ApplicationSystemTestCase
  setup do
    @rsvpqs_controller = rsvpqs_controllers(:one)
  end

  test "visiting the index" do
    visit rsvpqs_controllers_url
    assert_selector "h1", text: "Rsvpqs Controllers"
  end

  test "creating a Rsvpqs controller" do
    visit rsvpqs_controllers_url
    click_on "New Rsvpqs Controller"

    click_on "Create Rsvpqs controller"

    assert_text "Rsvpqs controller was successfully created"
    click_on "Back"
  end

  test "updating a Rsvpqs controller" do
    visit rsvpqs_controllers_url
    click_on "Edit", match: :first

    click_on "Update Rsvpqs controller"

    assert_text "Rsvpqs controller was successfully updated"
    click_on "Back"
  end

  test "destroying a Rsvpqs controller" do
    visit rsvpqs_controllers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Rsvpqs controller was successfully destroyed"
  end
end
