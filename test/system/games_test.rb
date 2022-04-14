require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Can't build from letters" do
    visit new_url
    click_on "Play"
    post "/score",
      params: {  word: "bison", letters: "B I S O N F V C D D" }
    assert_text "Congratulations!"
    assert_text "can't be built"
  end
end
