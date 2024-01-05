## Objective:  

Design and implement a Ruby on Rails-based Treasure Hunt game that revolves around a
RESTful API. The primary goal is to evaluate your ability to create an interactive game, handle
user input, implement game logic, and ensure security within the Ruby on Rails framework.

## User Interaction:  
Users can submit guesses for the treasure's location through the API.
Implement input validation to ensure each submission includes a valid email address and
coordinates (latitude and longitude).

## Game Logic:  
Calculate the distance between user-submitted coordinates and the actual treasure location.
If the distance is less than 1000 meters, mark the user as a winner.
Send an email confirmation to the user when they become a winner.
A user can become a winner only once.

## Rate Limiting:  
Restrict each user to a maximum of 5 guesses per hour.
Implement rate limiting and respond with appropriate error messages if the limit is exceeded.

## Winner List Endpoint:  
Implement an API endpoint allowing users to fetch a list of winners sorted by distance.
Optionally include sorting options (ascending, descending) and pagination.

## Testing:
Write tests to ensure the correctness of your API endpoints.

##T echnology Stack:
Use Ruby on Rails as the web framework.
Choose a suitable database or data store (e.g., PostgreSQL, MySQL) for storing game data
securely.
You can use any library.

## Game Interface (Optional):
(Optional) Create a basic HTML interface for testing purposes only. The primary focus is on the
REST API.

## Submission:
Upload your implementation to a GitHub repository.