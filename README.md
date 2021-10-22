# Homework 2 description - Specifications.

Needs to support 2 types of users:
- customers
- taxi drivers

For each user we need:
- full name
- age
- email
- password

Email is the username to login.
Email in database must be unique and have a valid format.
All users are at least 18 years old.

## Booking a taxi
Customer provides pickup and dropoff address and the estimated distance to cover on the entire journey.
(can do eiter as input or calculate yourself)
Pickup and dropoff must be filled in and not be the same.
Distance never smaller than 0.

### Submission
Automatically select available taxi that covers distance in lowest price.
If many taxis with lowest price, take one with least amount of completed rides.

No ride available -> notification
Ride available -> notification with info about booked taxi containing:
- taxi capacity - seats
- price of entire journey (based on distance)
- taxi location (or distance to pickup address.)
- full name of taxi drives

!! Store price of cost per km of each taxi.

## Required operations
- create_booking
- display_booking_list
- display_booking_info
- complete_ride

!! Database migrations, corresponding routes, views,templates.
!! Only authorized users perform the operations
-> Non authorized -> notification

## Required statuses:
- Booking
  - ACCEPTED
  - REJECTED

- Taxi
  - BUSY
  - AVAILABLE

- Allocation
  - ALLOCATED
  - COMPLETED
!! Need to implement allocation entity.

## TODO
- Gherkin BDD cycle - user stories and acceptance tests
- TDD cycle - unit tests and logic verificaton, assertions.


_______

#### Execution plan
0. Fill database with locations
  - Can either make it so users fill in distance
  - Or we calculate the distance using some formula

1. Create login page tests
  - Page generation
  - Login for customer
  - Login for taxi driver

2. Booking page tests
  - Page generation
  - Booking only accessible as a customer
  - Booking confirmation on user booking
    - Show confirmation message and show estimated time for arrival
  - Booking rejection on no free taxis
