Feature: Add Category
  In order to organize the needs
  As an admin
  I want to add and view categories

	Background:
		Given users with the following data:
    |name         |email                                |password     |type     |
    |Alaa Shafaee |alaa.shafaee92@gmail.com             |ABCxyz123    |admin    |
    |Nada Nasr    |nadanasreldin@gmail.com              |ABCxyz123    |admin    |
    |Dalia        |dalia.william@gmail.com              |ABCxyz123    |admin    |


  Scenario: View add Category form
    Given I am logged in as Alaa Shafaee
    And I am in the categories view
    Then I should see labels and headers for the adding a category
    And I should see a dropdown for selecting the parent category

  Scenario: View the side menu with "categories" active
    Given I am logged in as Alaa Shafaee
    And I am in the categories view
    Then I should see categories active in the sidebar menu

  Scenario: Add a new Category to a parent Category
    Given I am logged in as Alaa Shafaee
    And I am in the categories view
    When I fill in "category_name" with "sample parent category"
    And I click the "Add Category" button
    And I fill in "category_name" with "sample child category"
    And I select "sample parent category" as "category_parent"
    And I click the "Add Category" button
    Then the number of categories should be "3" because catgeory others is inserted by default
    And I should see a flash message saying "The category was successfully added."
    And there should be a category called "sample child category" with parent "sample parent category"
    And "sample parent category" has 1 child

  Scenario: Add an invalid category
    Given I am logged in as Alaa Shafaee
    And I am in the categories view
    And I click the "Add Category" button
    Then the number of categories should be "1" because catgeory others is inserted by default
    And I should see a flash message saying "Name Category name shouldn't be blank"
