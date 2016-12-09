Given(/^I navigate to Google Search$/) do
  visit_page(ChallengePage)
end

When(/^I search "([^"]*)"$/) do |text|
  on_page(ChallengePage).search_google(text)
end

And(/^I choose result number "([^"]*)"$/) do |num|
  on_page(ChallengePage).find_result_by_number(num)
end

And(/^I click "([^"]*)"$/) do |option|
  if option == "Save to Short list"
    on_page(ChallengePage).save_to_short_list
  end
end

Then(/^I see the "([^"]*)" results page$/) do |tab|
  on_page(ChallengePage).navigate_tabs(tab)

  fail unless on_page(ChallengePage).shopping_section?
end

And(/^I add a note "([^"]*)"$/) do |text|
  on_page(ChallengePage).saved_actions("Add note")
  on_page(ChallengePage).note_text(text)
  $text = text
end

Given(/^I have signed into my google account$/) do
  on_page(ChallengePage).sign_in_to_google
end

Then(/^I should see it succesfully added$/) do
  on_page(ChallengePage).verify_note_saved
  on_page(ChallengePage).review_note($text)
  on_page(ChallengePage).reset_shortlist
end