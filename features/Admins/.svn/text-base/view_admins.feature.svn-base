Feature: View Admins
  In order to get admins' names and emails
  As an admin
  I want to view a list of admins

	Background:
		Given users with the following data:
    |name         |email                                |password     |type     |
    |Alaa Shafaee |alaa.shafaee92@gmail.com             |ABCxyz123    |admin    |
    |Nada Nasr    |nadanasreldin@gmail.com              |ABCxyz123    |admin    |
    |Dalia        |dalia.william@gmail.com              |ABCxyz123    |admin    |


  Scenario: View a list of admins
    Given I am logged in as Alaa Shafaee
    And I am in the admins view
    And  email "alaa.shafaee92@gmail.com" belongs to "Alaa Shafaee"
    Then I should see the names and emails of admins
    #And I should see a label called Admins and a table
    And I should not see delete buttons

  Scenario: View delete buttons in case of super Admin
    Given I am logged in as Alaa Shafaee
    And email "alaa.shafaee92@gmail.com" belongs to "Alaa Shafaee"
    And "alaa.shafaee92@gmail.com" is SuperAdmin
    And I should see delete button next to each admin except me

  Scenario: View delete buttons in case of super Admin
    Given I am logged in as Alaa Shafaee
    And "alaa.shafaee92@gmail.com" is SuperAdmin
    #Then I can delete another admin

#NOTEEEEEEE::: This is an old story. So I did not complete the test because I do not have to test it.
