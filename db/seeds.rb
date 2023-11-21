game = FactoryBot.create(:game)
FactoryBot.create(:user, :admin, email: 'admin@example.com')
FactoryBot.create(:user, :winner, game: game, email: 'winner@example.com')
FactoryBot.create(:user, username: 'this_guy', email: 'player1@example.com', game: gxame)

