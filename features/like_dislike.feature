Feature: Like or dislike a comment
	In order to like or dislike a comment
	As a customer
	I want to click on icons that will increment the number of likers or dislikers

Scenario: Like a comment
	Given the following customers exists:
		| name   | email           | password | location |
		| tester | tester@test.com | password | egypt    |
	And I have the following categories:
    |   name    |
    |Electronics|
	And the following needs exists with category "Electronics":
    | name  | description | category_name |
    | Radio | am fm       | Electronics   |
	When I go to the customers sign in page
	Then I can fill the "customer[email]" with "tester@test.com"
	And I can fill the "customer[password]" with "password"
	Then I press the "Log in" button
	Then I visit the customer needs "Radio" page
	Then I press the "iNeed" button
	Then I can fill the "comment" with "hello world"
	Then I press the "Comment" button
	Then I press the "Like" link
	Then it should say "1 liked this."

Scenario: Disike a comment
	Given the following customers exists:
		| name   | email           | password | location |
		| tester | tester@test.com | password | egypt    |
	And I have the following categories:
    |   name    |
    |Electronics|
	And the following needs exists with category "Electronics":
    | name  | description | category_name |
    | Radio | am fm       | Electronics   |
	When I go to the customers sign in page
	Then I can fill the "customer[email]" with "tester@test.com"
	And I can fill the "customer[password]" with "password"
	Then I press the "Log in" button
	Then I visit the customer needs "Radio" page
	Then I press the "iNeed" button
	Then I can fill the "comment" with "hello world"
	Then I press the "Comment" button
	Then I press the "Dislike" link
	Then it should say "1 disliked this."

Scenario: Like a disliked comment
	Given the following customers exists:
		| name   | email           | password | location |
		| tester | tester@test.com | password | egypt    |
	And I have the following categories:
    |   name    |
    |Electronics|
	And the following needs exists with category "Electronics":
    | name  | description | category_name |
    | Radio | am fm       | Electronics   |
	When I go to the customers sign in page
	Then I can fill the "customer[email]" with "tester@test.com"
	And I can fill the "customer[password]" with "password"
	Then I press the "Log in" button
	Then I visit the customer needs "Radio" page
	Then I press the "iNeed" button
	Then I can fill the "comment" with "hello world"
	Then I press the "Comment" button
	Then I press the "Dislike" link
	Then I press the "Like" link
	Then it should say "1 liked this."
	And it should say "0 disliked this."

Scenario: Dislike a liked comment
	Given the following customers exists:
		| name   | email           | password | location |
		| tester | tester@test.com | password | egypt    |
	And I have the following categories:
    |   name    |
    |Electronics|
	And the following needs exists with category "Electronics":
    | name  | description | category_name |
    | Radio | am fm       | Electronics   |
	When I go to the customers sign in page
	Then I can fill the "customer[email]" with "tester@test.com"
	And I can fill the "customer[password]" with "password"
	Then I press the "Log in" button
	Then I visit the customer needs "Radio" page
	Then I press the "iNeed" button
	Then I can fill the "comment" with "hello world"
	Then I press the "Comment" button
	Then I press the "Like" link
	Then I press the "Dislike" link
	Then it should say "1 disliked this."
	And it should say "0 liked this."

Scenario: Undo Like a comment
	Given the following customers exists:
		| name   | email           | password | location |
		| tester | tester@test.com | password | egypt    |
	And I have the following categories:
    |   name    |
    |Electronics|
	And the following needs exists with category "Electronics":
    | name  | description | category_name |
    | Radio | am fm       | Electronics   |
	When I go to the customers sign in page
	Then I can fill the "customer[email]" with "tester@test.com"
	And I can fill the "customer[password]" with "password"
	Then I press the "Log in" button
	Then I visit the customer needs "Radio" page
	Then I press the "iNeed" button
	Then I can fill the "comment" with "hello world"
	Then I press the "Comment" button
	And I press the "Like" link
	Then I press the "undo like/dislike" link
	Then it should say "0 liked this."

	Scenario: Undo Dislike a comment
	Given the following customers exists:
		| name   | email           | password | location |
		| tester | tester@test.com | password | egypt    |
	And I have the following categories:
    |   name    |
    |Electronics|
	And the following needs exists with category "Electronics":
    | name  | description | category_name |
    | Radio | am fm       | Electronics   |
	When I go to the customers sign in page
	Then I can fill the "customer[email]" with "tester@test.com"
	And I can fill the "customer[password]" with "password"
	Then I press the "Log in" button
	Then I visit the customer needs "Radio" page
	Then I press the "iNeed" button
	Then I can fill the "comment" with "hello world"
	Then I press the "Comment" button
	And I press the "Dislike" link
	Then I press the "undo like/dislike" link
	Then it should say "0 disliked this."