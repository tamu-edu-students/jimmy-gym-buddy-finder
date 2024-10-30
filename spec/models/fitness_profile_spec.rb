require 'rails_helper'

RSpec.describe FitnessProfile, type: :model do
  let(:user) { create(:user) }

  it 'is valid with valid attributes' do
    fitness_profile = FitnessProfile.new(
      fitness_goals: 'Lose weight',
      workout_types: 'Running',
      gender: 'Male',
      age_range_start: '18',
      age_range_end: '28',
      gym_locations: 'Student Rec Center, Polo Road Rec Center',
      gender_preferences: 'Male, Female',
      activities_with_experience: 'Soccer:Amateur|Basketball:Beginner',
      workout_schedule: 'Monday=06:00-07:00|Wednesday=08:00-09:00',
      user: user
    )
    expect(fitness_profile).to be_valid
  end

  it 'is not valid without a fitness goal' do
    fitness_profile = FitnessProfile.new(
      fitness_goals: nil,
      gym_locations: 'Student Rec Center, Polo Road Rec Center',
      user: user
    )
    expect(fitness_profile).not_to be_valid
  end

  it 'is not valid without a user' do
    fitness_profile = FitnessProfile.new(
      fitness_goals: 'Lose weight',
      gym_locations: 'Student Rec Center, Polo Road Rec Center',
      user: nil
    )
    expect(fitness_profile).not_to be_valid
  end

  describe '#activities_array' do
    it 'returns an array of activities with experience levels' do
      fitness_profile = FitnessProfile.new(
        activities_with_experience: 'Soccer:Amateur|Basketball:Beginner'
      )
      expected_result = [
        { 'activity' => 'Soccer', 'experience' => 'Amateur' },
        { 'activity' => 'Basketball', 'experience' => 'Beginner' }
      ]
      expect(fitness_profile.activities_array).to eq(expected_result)
    end

    it 'returns an empty array if activities_with_experience is nil' do
      fitness_profile = FitnessProfile.new(activities_with_experience: nil)
      expect(fitness_profile.activities_array).to eq([])
    end
  end

  describe '#schedule_hash' do
    it 'returns a hash of workout days with start and end times' do
      fitness_profile = FitnessProfile.new(
        workout_schedule: 'Monday=06:00-07:00|Wednesday=08:00-09:00'
      )
      expected_result = {
        'Monday' => { 'start' => '06:00', 'end' => '07:00' },
        'Wednesday' => { 'start' => '08:00', 'end' => '09:00' }
      }
      expect(fitness_profile.schedule_hash).to eq(expected_result)
    end

    it 'returns an empty hash if workout_schedule is nil' do
      fitness_profile = FitnessProfile.new(workout_schedule: nil)
      expect(fitness_profile.schedule_hash).to eq({})
    end
  end

  describe '#workout_types_array' do
    it 'returns an array of workout types' do
      fitness_profile = FitnessProfile.new(workout_types: 'Running, Swimming, Cycling')
      expected_result = ['Running', 'Swimming', 'Cycling']
      expect(fitness_profile.workout_types_array).to eq(expected_result)
    end

    it 'returns an empty array if workout_types is nil' do
      fitness_profile = FitnessProfile.new(workout_types: nil)
      expect(fitness_profile.workout_types_array).to eq([])
    end
  end

  describe '#gym_locations_array' do
    it 'returns an array of gym locations' do
      fitness_profile = FitnessProfile.new(gym_locations: 'Student Rec Center, Southside Rec Center')
      expected_result = ['Student Rec Center', 'Southside Rec Center']
      expect(fitness_profile.gym_locations_array).to eq(expected_result)
    end

    it 'returns an empty array if gym_locations is nil' do
      fitness_profile = FitnessProfile.new(gym_locations: nil)
      expect(fitness_profile.gym_locations_array).to eq([])
    end
  end

  describe '#gender_preferences_array' do
    it 'returns an array of gender preferences' do
      fitness_profile = FitnessProfile.new(gender_preferences: 'Male, Female')
      expected_result = ['Male', 'Female']
      expect(fitness_profile.gender_preferences_array).to eq(expected_result)
    end

    it 'returns an empty array if gender_preferences is nil' do
      fitness_profile = FitnessProfile.new(gender_preferences: nil)
      expect(fitness_profile.gender_preferences_array).to eq([])
    end
  end
end
