class FitnessProfile < ApplicationRecord
  belongs_to :user

  validates :age_range_start, presence: true, 
            numericality: { only_integer: true, greater_than_or_equal_to: 18, less_than_or_equal_to: 60 }
  validates :age_range_end, presence: true, 
            numericality: { only_integer: true, greater_than_or_equal_to: 18, less_than_or_equal_to: 60 }
  validates :gym_locations, presence: true
  validates :workout_types, presence: true

  # Helper methods to handle comma-separated values
  def gym_locations_array
    gym_locations.to_s.split(',').map(&:strip)
  end

  def workout_types_array
    workout_types.to_s.split(',').map(&:strip)
  end

  def gender_preferences_array
    gender_preferences.to_s.split(',').map(&:strip)
  end

  def activities_array
    return [] unless activities_with_experience
    activities_with_experience.split('|').map do |activity_exp|
      activity, experience = activity_exp.split(':').map(&:strip)
      { 'activity' => activity, 'experience' => experience }
    end
  end

  def schedule_hash
    return {} unless workout_schedule
    schedule = {}
    workout_schedule.split('|').each do |day_time|
      day, times = day_time.split('=')
      start_time, end_time = times.split('-')
      schedule[day.strip] = {
        'start' => start_time.strip,
        'end' => end_time.strip
      }
    end
    schedule
  end

end
