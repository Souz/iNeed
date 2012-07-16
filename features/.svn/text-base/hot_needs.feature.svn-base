Feature: Hot needs
  In order to view my hot needs
  As a supplier
  I want to view hot needs  

  Background:
    Given users with the following data:
      | name  | email           |password  | type     |
      | Mirna | mirna@mirna.com | 123456   | supplier |

  Scenario: No hot needs
    Given needs with the following data:
      | name | number_needers |
      | ipad | 0              |
      | 6600 | 0              |
    Given I am in the hot needs view
    Then I should see "There are no hot needs at the moment." on the page


  Scenario: View hot needs
    Given needs with the following data:
      | name | number_needers |
      | ipad | 15             |
      | 6600 | 7              |

    Given I am in the hot needs view
    Given I am logged in as Mirna
    Then I should see "ipad" in a link
    Then I should not see "6600" in a link
    Then I should see "show need" in a link
    Then I should see "place an offer" in a link
    And I should see "Track" in a button
    Then I should see "Notify" in a button

