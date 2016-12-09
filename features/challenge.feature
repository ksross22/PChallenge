Feature: Pendo Automation Code Challenge
  As a User
  I want to navigate to Google shopping
  So that I can buy a Hacky Sack


Background: Sign into Google
  Given I navigate to Google Search
  And I have signed into my google account

Scenario: Save to Short List
  Given I search "hacky sack"
  When I see the "Shopping" results page
  And I choose result number "4"
  And I click "Save to Short list"
  And I add a note "Please buy me"
  Then I should see it succesfully added
