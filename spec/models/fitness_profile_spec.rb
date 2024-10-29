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
      gym_locations: 'dummy gym location',
      user: user
    )
    expect(fitness_profile).to be_valid
  end

  it 'is not valid without a fitness goal' do
    fitness_profile = FitnessProfile.new(fitness_goals: nil, user: user)
    expect(fitness_profile).not_to be_valid
  end

  it 'is not valid without a user' do
    fitness_profile = FitnessProfile.new(fitness_goals: 'Lose weight', user: nil)
    expect(fitness_profile).not_to be_valid
  end
end
