Feature: Digest email
  In order to know my updates regarding my emails
  As an supplier
  I want to receive digest email

	Background:
		Given users with the following data:
    |name         |email                    	         |password		|type     |
    |Essam Mohsen |ma7ma7.2011@gmail.com	   	         |75467546		|supplier |

  Scenario: Digest email
	Given I login to gmail with username "ma7ma7.2011" and password "75467546"
	And I open email message with subject "Offers updates"
	And I should see in email message "My Offers"
	Then I clear my inbox