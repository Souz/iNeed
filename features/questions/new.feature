Feature: New Feedback Question
	In order to maintain a high level of customer satisfaction
	As an admin
	I can add a new question to the default feedback form

	Background:
		Given users with the following data:
    |name         |email                                |password     |type     |
    |Nada Nasr    |nadanasreldin@gmail.com              |ABCxyz123    |admin    |
    
	Scenario: Successfully add a new question
		Given I am logged in as Nada Nasr
      And I am on the questions page
    Then I should see a form
      And I should see "click to add a new question" on the page
      And I should see "The answers to all questions are the following \"Strongly agree\", \"Agree\", \"Neutral\", \"Disagree\" and \"Strongly disagree\"." on the page
      And I should see "Enter a statement for which you expect a positive answer. For example, \"I was satisfied with the quality of the product.\" and not \"How was the quality of the product?\"." on the page
      And I should see "The weights of the questions contribute to the rating of the supplier as follows: \"Strongly disagree\" has a weight of 5, \"Agree\" a weight of 4, and so on.." on the page
    When I enter "The speed of delivery was fast"
      And I press the "Add question" button
    Then I should see "The speed of delivery was fast" on the page

  Scenario: Failure to add a question because text box was left empty
    Given I am logged in as Nada Nasr
      And I am on the questions page
    When I press the "Add question" button
      Then I should see "content can't be blank" on the page