class Game < ApplicationRecord
  class GameError < StandardError; end
  validates :latitude, :longitude, presence: true
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode if Proc.new { longitude_changed? || latitude_changed? }
  before_save :update_address_name if :address_changed?

  def self.generate_new 
    create!(generate_coordinates)
  rescue ActiveRecord::RecordInvalid => e
    # NOTE: Custom class to keep from rescuing errors we don't know enough yet to rescue from. 
    raise GameError
  end

  # NOTE: Implementation seems likely to change in the future, so I'm moving coordinate generation
  # here; all the generation really cares about right now is that it gets some coordinates.
  # Changed from original use of Faker gem for lat & lng to hardcoded coordinates pending 
  # better solution for randomly generating valid, geocodable lat/lng pairs.
  def self.generate_coordinates
    { latitude: 37.7899932, longitude: -122.4008494 }
  end

  def play(player_guess_coordinates)
    lat, lng = player_guess_coordinates.split(',').map(&:to_f)
    distance = distance_from([lat, lng])

    if distance <= 1
      { success: true,  message: winner_message(lat, lng, distance), distance: distance }
    else
      { success: false, message: "Sorry, try again. you are #{distance}km away." }
    end
  end

  def geocoder_name(latitude, longitude)
    result = Geocoder.search([latitude, longitude]).first
    result.data['name']
  end

  private 

  def update_address_name
    addr = address || geocoder_name(latitude, longitude)
    self.name = addr.split(',').shift
  end

  def winner_message(lat, lng, distance)
    "Congratulations! You guessed correctly. The actual location was latitude: #{lat}, longitude: #{lng}, which is #{name}. "\
    "You guessed #{lat}, #{lng}, which is #{geocoder_name(lat, lng)}. "\
    "You were within #{distance}km of the actual location."
  end
end
