Feature: Publish Offer
  In order to publish offers
  As a supplier
  I want to see not published offers and publish them
  
Background:
	Given the following user exists:
		|name			|email                |password   | location  | approved  | type      |
		|Nour			|nourhan67@gmail.com  |nnnnnn	    | cairo     | true      | supplier  |

  Given the following category exists:
      | name    |
      | Mobiles |
	
	Given the following need exists:
		| name    | description | category_name	|
		| iPhone 	| Phone       | Mobiles       |
      
  Given the following offer exists:
      | quantity  | min_quantity  | price | warranty  | deleted | published |
      |  200      | 100           | 3000  | 24        | false   | false     |

  Scenario: Publish an offer
    Given I sign in as Nour
    When I click on the "Publish Now!" button
    Then I should go to summary page
    When I click on the "Publish" button
    Then I should go to myoffers page
    And I should see my offer published

