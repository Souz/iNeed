Feature: New Project
  In order to search for a specific need
  As a user
  I should be able to filter my search results

  Scenario: Filter Needs
    Given the following needs exists:
      | name    | description | category_name |
      | iPhone4 | Phone       | Electronics   |
      | Frisbee | Disc        | Sports        |
    Given the following categories exists:
      |   name    |
      |Electronics|
      | Sports    |
    When I go to the needs page
      And I choose Electronics as the category
      And I press the "Filter" button
    Then I should go to the filter page
    Then I should see a text field containing iPhone4
    Then I shouldn't see a text field containing Frisbee

