Feature: View Feedback Questions
	In order to edit, delete and new questions
  As an admin
  I can view feedback questions

  Background:
    Given users with the following data:
    |name         |email                                |password     |type     |
    |Tarek Mehrez |tarekmmehrez@gmail.com               |nnnnnn       |admin    |
      And questions with the following data:
      |content                                            |
      |Did the supplier's services met your requirements? |
      |Did you receive your product one time ?            |
    

  Scenario: Successfully view all questions
    Given I am logged in as Tarek Mehrez
      And I am on the questions page
    Then I should see all questions

