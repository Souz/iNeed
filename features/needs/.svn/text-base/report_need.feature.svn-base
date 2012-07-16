Feature: Report need
  In order to report a need
  As a customer 
  I should be able to go to customer needs page

   

Scenario: Successfully report need

    Given the following customers exists:
      | name   | email              | password | location |
      | marina | marina34@hotmail.com | password | location |

    And I have the following categories:
      |   name    |
      | Apple     |

    And the following needs exists with category "Apple":
      | name        | description| category_name |
      | iPhone45    | touch      | Apple         |


    When I go to the customers sign in page
    Then I can fill the "customer[email]" with "marina34@hotmail.com"
    	And I can fill the "customer[password]" with "password"
    Then I press the "Log in" button
    Then I visit the customer needs "iPhone45" page 
    	And I choose 'spam'
    	And I press the "Submit" button
 

