Welcome to Treasure Hunt. For now, all interactions are via the RESTful api, so you'll need to break out your cURLing stones or fire up Postman or, heck, I guess you can just slap URLs into a browser address bar. You're getting back JSON whatever you do. 

### Dependencies

- Rails 7.0.8
- Ruby 3.2.0
- Postgres 14

### Getting Started 

Clone down the repo, then run `bundle install`, `bundle exec rails db:create`, `bundle exec rails db:migrate` 

That's all there is to it. 

### Playing

**NOTE**: you'll need to include `email=your_email` with basically every request you send here, so if it isn't mentioned explicitly in these steps, that's just an oversight and you should still include it. 

1. register your email address. There's no frontend here, so use whatever tool you'd like. Here's an example cURL reuqest for registration: 

  ```   
  curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" "http://localhost:3000/users?email=somebody@example.com"  
  ``` 
  
  If you'd like to include a username, you can add `&username=your_username` to your params. 
  
2. Join a game! Include your email address as a parameter (`email=something@example.com`) and send a POST to `/games`: 

  ```
  curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" "http://localhost:3000/users?email=somebodyelse@example.com"
  ```
  
  The response will include your game_id. Include that with your guesses in the next step. 
  
3. Now it's time to play. This is done by sending a `PATCH` request to `/games/:your_game_id` with, as always, your email as a parameter, along with a set of coordinates, formatted like this: `coordinates=latitude, longitude`. Here's an example:  

  ```
  curl -X PATCH -H "Content-Type: application/json" -H "Cache-Control: no-cache" "http://localhost:3000/games/1?email=mnolan@example.com&coordinates=37.7899932%2C%20-122.4008494"
  ```
  
  If your coordinates are within 1km of the game's location, you win! You'll receive an email acknowledging that. If not, you'll be notified, along with the distance from your guess to the game's location. 

### That's Really It. But know the following: 

1. You can only guess 5 times per hour. This is a rolling rate limit, so if you guess 5 times in quick succession, you'll have to wait until an hour from the first guess to go again. Then an hour from the second guess to go again, etc. etc. 

2. You can be a winner only once. For now, we've decided that that means you can play one game, and then, once you've won, you can bask in the glow of that victory forever -- but if you want to play again, you'll have to outfox our airtight security by submitting a different email address. 
3. The above could change. This was all done by just one person, but he's using third-person lanugage now and used first-person singular in the previous point -- and really, if this dude can't even pick a case, what's the chances he's real decisive with his rules, amirite?
4. You can check out how you stack up against other winners, once you've registered, by visiting `/users`, with your email address: 

  ```
	curl -X GET -H "Content-Type: application/json" -H "Cache-Control: no-cache" "http://localhost:3000/usersemail=somebodyelse@example.com"
	
  ```
5. This game does not really resemble a treasure hunt in any meaningful fasion, but that's the first name that occurred to me, and it seemed good enough at the time. *shrug*
