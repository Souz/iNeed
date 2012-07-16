Feature: Sort
  In order to search for a specific need
  As a user
  I should be able to sort my search results

  Background: Sort Needs
    Given the following needs exists:
      | name        | description      | category_name |    
      | NeedTany 1  | Need walahi      | Others        |
      | NeedTany 2  | Need tany oksem  | Others        |

    Given the following customers exists:
      | name       | email                 | password | location |
      | tarek      | tarek@gmail.com       | 123456   | Cairo    |

    
    Scenario: View search form
    When I go to the customers sign in page
    Then I can fill the "customer[email]" with "tarek@gmail.com"
      And I can fill the "customer[password]" with "123456"
    Then I press the "Log in" button
    When I go to the needs page
    Then I should see a dropdown for selecting the sorting criteria 


    Scenario: Sort needs by name ascendingly
    When I go to the customers sign in page
    Then I can fill the "customer[email]" with "tarek@gmail.com"
      And I can fill the "customer[password]" with "123456"
    Then I press the "Log in" button
    When I go to the needs page
    And I select "Ascending", from: "submit"
    And I click the "Sort" button
    Then I should see a text field containing NeedTany 1
    Then I shouldn't see a text field containing NeedTany 2 


    Scenario: Sort needs by name descendingly
    When I go to the customers sign in page
    Then I can fill the "customer[email]" with "tarek@gmail.com"
      And I can fill the "customer[password]" with "123456"
    Then I press the "Log in" button
    When I go to the needs page
    And I select "Ascending", from: "submit"
    And I click the "Sort" button
    Then I should see a text field containing NeedTany 2
    Then I shouldn't see a text field containing NeedTany 1  
    


