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
  def self.generate_coordinates
    { latitude: Faker::Address.latitude, longitude: Faker::Address.longitude }
  end

  def update_address_name
    self.name = address.split(',').shift
  end
end
