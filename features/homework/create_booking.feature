Feature: Taxi booking
  As a customer
  Such that I go to a destination
  I want to book a taxi ride

  Scenario: Booking via STRS' web page (with confirmation)
    Given John logs into the system using his credentials
      | email         | password | name         | age | role     |
      | john123@ut.ee | 1234     | John Johnson | 44  | costumer |
    And the following taxi drivers are on duty
      | email            | password | name      | age | role   | id |
      | john123@takso.ee | 1234     | John Joe  | 44  | driver | 2  |
      | john321@takso.ee | 1234     | John John | 43  | driver | 3  |
    And the following taxis are on duty
      | id | location      | status    | price | completed_rides | capacity |
      | 2         | Juhan Liivi 2 | available | 6.0   | 0               | 4        |
      | 3         | Kalevi 4      | busy      | 13.0  | 2               | 2        |
    And I want to go from "Street" to "Road" with distance 5.0
    And I open the STRS's web page
    And I enter the booking information
    When I submit the booking request
    Then I should receive a confirmation message

# Scenario: Booking via STRS' web page (with rejection)
#     Given John logs into the system using his credentials
#     | email          | password | name         | age | role     |
#     | john123@ut.ee  | 1234     | John Johnson | 44  | costumer |
#   And the following taxi drivers are on duty
#     | email             | password | name         | age | role     | id|
#     | john123@takso.ee  | 1234     | John Joe     | 44  | driver   | 2 |
#     | john321@takso.ee  | 1234     | John John    | 43  | driver   | 3 |
#   And the following taxis are on duty
#     | driver_id|location      | status    | price   | completed_rides| capacity |
#     | 2        |Juhan Liivi 2 | busy      | 6.0     |  0             |    4     |
#     | 3        |Kalevi 4      | busy      | 13.0    |  2             |    2     |
#   And I want to go from "Juhan Liivi 2" to "Muuseumi tee 2"
#   And I open the STRS's web page
#   And I enter the booking information
#   When I submit the booking request
#   Then I should receive a rejection message
