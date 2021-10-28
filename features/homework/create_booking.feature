Feature: Taxi booking
  As a customer
  Such that I go to a destination
  I want to book a taxi ride

  Scenario: Booking via STRS' web page (with confirmation)
    Given John is logged into the system using his credentials
      | username | password | name         | age | role     |
      | john123  | 1234     | John Johnson | 44  | costumer |
    And the following taxis are on duty
      | username | driver_id|location      | status    | price | completed_rides| capacity |
      | peeter88 | 1        |Juhan Liivi 2 | available | 6     |  0             |    4     |
      | juhan85  | 2        |Kalevi 4      | busy      | 13    |  2             |    2     |
    And I want to go from "Juhan Liivi 2" to "Muuseumi tee 2"
    And I open the STRS's web page
    And I enter the booking information
    When I submit the booking request
    Then I should receive a confirmation message

  Scenario: Booking via STRS' web page (with rejection)
    Given John is logged into the system using his credentials
      | username | password | name         | age | role     |
      | john123  | 1234     | John Johnson | 44  | costumer |
    And the following taxis are on duty
      | username | driver_id|location      | status    | price | completed_rides| capacity |
      | peeter88 | 1        |Juhan Liivi 2 | busy      | 6    |  0             |    4     |
      | juhan85  | 2        |Kalevi 4      | busy      | 13   |  2             |    2     |
    And I want to go from "Juhan Liivi 2" to "Muuseumi tee 2"
    And I open the STRS's web page
    And I enter the booking information
    When I submit the booking request
    Then I should receive a rejection message

# driver_id, location, price, completed_rides, status, capacity
