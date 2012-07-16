Feature: Report comment
  In order to report a comment
  As a customer 
  I should be able to go to customer needs page

   

Scenario: Successfully report comment

    Given the following customers exists:
      | name   | email              | password | location |
      | Doha   | doha@gmail.com     | 123456   | Cairo    |

    And I have the following categories:
      |   name    |
      | Others    |

    And the following needs exists with category "Others":
      | name        | description                    | category_name |    
      | Need 1      | I NEED REPORT TO WORK !!!      | Others        |

    And the following comments exists:
      | content | created_on                |
      | hello   | 2012-05-25T17:19:49+03:00 | 


    When I go to the customers sign in page
    Then I can fill the "customer[email]" with "doha@gmail.com"
      And I can fill the "customer[password]" with "123456"
    Then I press the "Log in" button
    Then I visit the customer needs "Need 1" page
 
      And I choose 'Hate_Speech'
      And I press the "Submit" button
 
