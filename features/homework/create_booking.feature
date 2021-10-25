Feature: Taxi booking

  As a customer
  Such that I go to a destination
  I want to book a taxi ride

  Scenario: Booking via STRS' web page (with confirmation)
    Given John is logged into the system using his credentials
      | username | password |
      | john123  | 1234     |
    And the following taxis are on duty
      | username | location      | status    |
      | peeter88 | Juhan Liivi 2 | busy      |
      | juhan85  | Kalevi 4      | available |
    And I want to go from "Juhan Liivi 2" to "Muuseumi tee 2"
    And I open the STRS's web page
    And I enter the booking information
    When I submit the booking request
    Then I should receive a confirmation message
