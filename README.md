Welcome to Treasure Hunt. For now, all interactions are via the RESTful api, so you'll need to break out your cURLing stones or fire up Postman or, heck, I guess you can just slap URLs into a browser address bar. You're getting back JSON whatever you do. 

Here's how it works: 
- create a user profile and get a token: 

- make sure you include this token in every request. 

- post your guesses to the endpoint, like so: 

- If you're within 1 km, you win! You'll get an email acknowledging this fact. I suggest you display it prominently on your LinkedIn account and include it in lieu of a cover letter with all future job applications. 

- If not, you can try again, though you only get 5 attempts per hour. 

- If you want to see how you stack up against other winners, you can include your game id (it'll be in the email, though it will also be included in responses to your guesses. 

- If you want to see how you stack up against winners for all games evar, just include `all_games=true` with your request. 

- You can become a winner only once. So if you want to play again, you'll have to use another email address. 
