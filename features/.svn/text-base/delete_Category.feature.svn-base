Feature: Delete Category
  In order to organize the needs
  As an admin
  I want to delete categories

  Background:
   Given users with the following data:
    |name         |email                                |password     |type     |
    |Alaa Shafaee |alaa.shafaee92@gmail.com             |ABCxyz123    |admin    |
    |Nada Nasr    |nadanasreldin@gmail.com              |ABCxyz123    |admin    |
    |Dalia        |dalia.william@gmail.com              |ABCxyz123    |admin    |

  Scenario: delete a leaf category that does not have any need.
    Given I am logged in as Alaa Shafaee
    And I have the following categories:
      |   name    |
      | Apple     |
    And I am in the categories view
    Then I press the "delete" link
    And I choose 'Delete all related needs'
    And I press the "Delete" button
    Then the number of categories should be "1" because catgeory others is inserted by default

  Scenario: delete a leaf category that does not have any need while selecting to remove the needs to category others.
    Given I am logged in as Alaa Shafaee
    And I have the following categories:
      |   name    |
      | Apple     |
    And I am in the categories view
    Then I press the "delete" link
    And I choose 'transfer needs to category others'
    And I press the "Delete" button
    Then the number of categories should be "1" because catgeory others is inserted by default

  Scenario: delete a category that has a need and delete needs.
    Given I am logged in as Alaa Shafaee
    And I have the following categories:
      |   name    |
      | Apple     |

    And I have the following categories:
      |   name    |
      | Apple     |

    And the following needs exists with category "Apple":
      | name        | description| category_name |
      | iPhone45    | touch      | Apple         |
    And I am in the categories view
    Then I press the "delete" link
    And I choose 'Delete all related needs'
    And I press the "Delete" button
    Then the number of needs should be "0"





  Scenario: Delete a parent Category
    Given I am logged in as Alaa Shafaee
    And I am in the categories view
    When I fill in "category_name" with "sample parent category"
    And I click the "Add Category" button
    And I fill in "category_name" with "sample child category"
    And I select "sample parent category" as "category_parent"
    And I click the "Add Category" button
    Then I press the "delete" link
    And I choose 'Delete all related needs'
    And I press the "Delete" button
    Then the number of categories should be "1" because catgeory others is inserted by default
