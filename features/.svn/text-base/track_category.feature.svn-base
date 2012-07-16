Feature: Track Category
  In order to track or untrack a Category
  As a supplier
  I want to see track or untrack buttons on a Category page 

  Background: The user is logged in
    Given a logged in supplier

  Scenario: Track
    Given categories with the following data:
      | name        | parent_name |
      | Books       |             |
      | Fiction     | Books       | 
    When I am on the page of "Books" Category
    And I click a link named "Track"
    Then I should see "UnTrack" in a link

    Scenario: Track Parent
    Given categories with the following data:
      | name        | parent_name |
      | Books       |             |
      | Fiction     | Books       |
    When I am on the page of "Books" Category
    And I click a button named "Track"
    Then I should see "UnTrack" in a link
    And I should see "UnTrack" in a button

    Scenario: Leaf Category
    Given categories with the following data:
      | name        | parent_name |
      | Books       |             |
      | Fiction     | Books       |
    When I am on the page of "Fiction" Category
    Then I should not see "UnTrack" in a link
    And I should see "Track" in a button
    And I should see "Back to" written on the page