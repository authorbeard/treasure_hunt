Welcome to Treasure Hunt. For now, all interactions are via the RESTful api, so you'll need to break out your cURLing stones or fire up Postman or, heck, I guess you can just slap URLs into a browser address bar. You're getting back JSON whatever you do. 

### Dependencies

- Rails 7.0.8
- Ruby 3.2.0
- Postgres 14

### Getting Started 

Clone down the repo, then run `bundle install`, `bundle exec rails db:setup`. 

That will seed the database with the following users: 

- admin user: `admin@example.com`
- winning user: `winner@example.com`
- current player: `player1@example.com`, game_id: 1
- rate-limited current player: `rate_limited@example.com`, game_id: 1

You can, of course, create new players by following the instructions below. 

*Additionally*, [This migration should ensure that the postgis extension to Postgres has been enabled](https://github.com/authorbeard/treasure_hunt/blob/6a5ecd684bc9afa541a0ba1637d6e98f1ac6de80/db/migrate/20231117154305_enable_postgis.rb#L1); if you get errors relating to geolocation, something might have gotten screwed up here; you can always trash the db/schema.rb file and start over with migrations if need be. There's not a whole heck of a lot going on in the db as yet.

### Playing

**NOTE**: you'll need to include `email=your_email` with basically every request you send here, so if it isn't mentioned explicitly in these steps, that's just an oversight and you should still include it. 

1. POST `/users`: Register your email address with a POST request. Here's an example cURL reuqest: 

  ```   
  curl -X POST "http://localhost:3000/users?email=somebody@example.com"  
  ``` 
  
  If you'd like to include a username, you can add `&username=your_username` to your params. 
  
2. POST `/games`: Join a game! Include your email address as a parameter (`email=something@example.com`) and send a POST to `/games`: 

  ```
  curl -X POST "http://localhost:3000/games?email=somebody@example.com"
  ```
  
  The response will include your game_id. Include that with your guesses in the next step. 
  
3. PATCH `/games`: Now it's time to play. This is done by sending a `PATCH` request to `/games/:your_game_id` with, as always, your email as a parameter, along with a set of coordinates, formatted like this: `coordinates=latitude, longitude`. Here's an example:  

  ```
  curl -X PATCH "http://localhost:3000/games/1?email=somebody@example.com&coordinates=37.7899932%2C%20-122.4008494"
  ```
  
  If your coordinates are within 1km of the game's location, you win! You'll receive an email acknowledging that. If not, you'll be notified, along with the distance from your guess to the game's location. 
  
4. GET `/users`: Once you've registered, if you include your email address as a parameter, `/users` will show you a list of winners: 

  ```
  curl -X GET "http://localhost:3000/users?email=somebody@example.com"
  ```  
  

### That's Really It. But know the following: 

1. You can only guess 5 times per hour. This is a rolling rate limit, so if you guess 5 times in quick succession, you'll have to wait until an hour from the first guess to go again. Then an hour from the second guess to go again, etc. etc. 

2. You can be a winner only once. For now, we've decided that that means you can play one game, and then, once you've won, you can bask in the glow of that victory forever -- but if you want to play again, you'll have to outfox our airtight security by submitting a different email address. 
3. The above could change. This was all done by just one person, but he's using third-person lanugage now and used first-person singular in the previous point -- and really, if this dude can't even pick a case, what's the chances he's real decisive with his rules, amirite?
4. This game does not really resemble a treasure hunt in any meaningful fasion, but that's the first name that occurred to me, and it seemed good enough at the time. *shrug*
