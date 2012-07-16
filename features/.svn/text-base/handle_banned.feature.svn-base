Feature: Handle banned users
  In order to prevent problems in the users' activity on the system
  As a system
  I should handle the activity of banned users

  Background:
    Given users with the following data:
    |name         |email                  |password     |type     |banned |
    |Tarek Mehrez |tarekmmehrez@gmail.com |nnnnnn       |admin    |nil    |
    |Mohamed      |mohamed@mail.com       |asdasda      |customer |true   |
    |Nada Nasr    |nadanasr@gmail.com     |123456       |customer |true   |
    |Sabahy       |hamdin@president.com   |567890       |supplier |true   |

      And the following categories exist:
      |name       | 
      |Electronics|
      |Books      |

      And the following needs exist:
      |name         |description            |category_name |customer    |
      |ipad         |ipad 2 Wifi + 3G       |Electronics   |Mohamed     |
      |Awlad Haretna|Novel by Naguib Mahfouz|Books         |Nada Nasr   |

    And the following comments with customer "Nada Nasr" and need "ipad":
      | content      | need_name | customer_name    | created_on |
      | hello world  | ipad      | Nada Nasr        | 2012-05-25T17:19:49+03:00 |


      And the following offers exist:
      |quantity |published |supplier  |name | need |
      | 5       |true      |Sabahy    |o    | ipad |

      And the following transactions exist:
      |offer        | supplier     |
      |o            | Sabahy       |


  Scenario: Successfully hanlde a banned customer's activities if he is not subscribed to a need
    Then I should unneed "Nada Nasr" from the need "ipad"
      And I should delete all comments of "Nada Nasr"

  Scenario: Successfully hanlde a banned supplier's activities
    Then I should delete all the offers of "Sabahy"