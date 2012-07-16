Feature: Automatically delete reported comments
In order to guarantee comment's ethics
Reported comments that exceeds x number of reports should be deleted

	Scenario: Successfully delete comment
  Given the following customers exists:
      | name    | email                | password | location |
      | marina  | marina@hotmail.com   | password | location |
      | dalia   | dalia@hotmail.com    | password | location |
      | nada    | nada@hotmail.com     | password | location |
      | sherry  | sherry@hotmail.com   | password | location |
    And I have the following categories:
      |   name    |
      | Apple     |

    And these needs with category "Apple" and customer "sherry":
      | name         | description| category_name | customer |          
      | MacBook      | touch      | Apple         | sherry   | 

    And the following comments with customer "sherry" and need "MacBook":
      | content      | need_name | customer_name | created_on |
      | hello world  | MacBook   | sherry        | 2012-05-25T17:19:49+03:00 |

    When I go to the customers sign in page
      Then I can fill the "customer[email]" with "dalia@hotmail.com"
      And I can fill the "customer[password]" with "password"
      Then I press the "Log in" button
      Then I visit the customer needs "MacBook" page
      And I choose 'Hate_Speech'
      And I press the "Submit" button
      Then I click the "Sign out" link

    When I go to the customers sign in page
      Then I can fill the "customer[email]" with "marina@hotmail.com"
      And I can fill the "customer[password]" with "password"
      Then I press the "Log in" button
      Then I visit the customer needs "MacBook" page
      And I choose 'Hate_Speech'
      And I press the "Submit" button
      Then I click the "Sign out" link

    When I go to the customers sign in page
      Then I can fill the "customer[email]" with "nada@hotmail.com"
      And I can fill the "customer[password]" with "password"
      Then I press the "Log in" button
      Then I visit the customer needs "MacBook" page
      And I choose 'Hate_Speech'
      And I press the "Submit" button
      Then I should not see comment content "hello world"
