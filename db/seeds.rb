game = FactoryBot.create(:game)
FactoryBot.create(:user, :admin, email: 'admin@example.com')
FactoryBot.create(:user, :winner, game: game, email: 'winner@example.com')
FactoryBot.create(:user, username: 'this_guy', email: 'player1@example.com', game: game)
rate_limited = FactoryBot.create(:limited_user, username: 'rate limited', email: 'rate_limited@example.com', game: game)
5.times { rate_limited.user_guesses.create }

