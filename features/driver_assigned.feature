Feature: Costumer pickup
  As a taxi driver
  Such that I go to pickup point and destination
  I want to pick up costumers

  Scenario: Booking via STRS' web page (with confirmation)
    Given the following costumers are requesting a ride
      | username | pickup_address| dropoff_address | distance |
      | jonas123 | Juhan Liivi 2 |  Muuseumi tee 2 | 5km      |
      | arm_in1  | Kalevi 4      | Tallinn 6       | 10 km    |
    And I am near "Juhan Liivi 2"
    And my status is available
    And I open STRS' web page
    When I get "jonas123" assigned
    Then my status is busy