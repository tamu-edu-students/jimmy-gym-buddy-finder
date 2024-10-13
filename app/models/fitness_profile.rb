class FitnessProfile < ApplicationRecord
  belongs_to :user
  validates :fitness_goals, presence: true
  validates :workout_types, presence: true
  validate :age_range_valid

  private

  def age_range_valid
    if age_range_start.present? && age_range_end.present? && age_range_start > age_range_end
      errors.add(:age_range_end, "must be greater than or equal to the start age")
    end
  end
end
