Feature: Taxi booking
  As a customer
  Such that I go to a destination
  I want to book a taxi ride

  Scenario: Booking via STRS' web page (with confirmation)
    Given Jake logs into the system using his credentials
      | email      | password | name       | age | role     | id |
      | jake@ut.ee | 1234     | Jake Blake | 44  | customer | 1  |
    And the following taxi drivers are on duty
      | email            | password | name      | age | role   | id |
      | john123@takso.ee | 1234     | John Joe  | 44  | driver | 2  |
      | john321@takso.ee | 1234     | John John | 45  | driver | 3  |
    And the following taxis are on duty
      | driver | location      | status    | price | completed_rides | capacity |
      | 2      | Juhan Liivi 2 | available | 6.0   | 0               | 4        |
      | 3      | Juhan Liivi 2 | busy      | 16.0  | 1               | 2        |
    And I want to go from "Street" to "Road" with distance "5.0"
    And I open the STRS's booking web page
    And I enter the booking information
    When I submit the booking request
    Then I should receive a confirmation message

  Scenario: Booking via STRS' web page (with rejection)
    Given Jake logs into the system using his credentials
      | email      | password | name       | age | role     | id |
      | jake@ut.ee | 1234     | Jake Blake | 44  | customer | 1  |
    And the following taxi drivers are on duty
      | email            | password | name     | age | role   | id |
      | john123@takso.ee | 1234     | John Joe | 44  | driver | 2  |
    And the following taxis are on duty but busy
      | driver_id | location      | status | price | completed_rides | capacity |
      | 2         | Juhan Liivi 2 | busy   | 6.0   | 0               | 4        |
      | 2         | Juhan Liivi 2 | busy   | 6.0   | 0               | 4        |
    And I want to go from "Juhan Liivi 2" to "Muuseumi tee 2" with distance "5.0"
    And I open the STRS's booking web page
    And I enter the booking information
    When I submit the booking request
    Then I should receive a rejection message
