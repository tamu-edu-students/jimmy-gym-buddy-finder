class FitnessProfile < ApplicationRecord
  belongs_to :user
  validates :fitness_goals, presence: true
  validates :workout_types, presence: true
end
