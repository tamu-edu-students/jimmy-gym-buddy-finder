# spec/controllers/fitness_profiles_controller_spec.rb

require 'rails_helper'

RSpec.describe FitnessProfilesController, type: :controller do
  let(:user) { create(:user) }
  let(:fitness_profile) { create(:fitness_profile, user: user) }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123456',
      info: {
        email: user.email,
        name: user.username
      },
      credentials: {
        token: 'mock_token',
        refresh_token: 'mock_refresh_token',
        expires_at: Time.now + 1.week
      }
    })
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    session[:user_id] = user.id
  end

  describe "GET #new" do
    it "assigns a new fitness profile to @fitness_profile" do
      get :new, params: { user_id: user.id }
      expect(assigns(:fitness_profile)).to be_a_new(FitnessProfile)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) do
      {
        age_range_start: 20,
        age_range_end: 30,
        fitness_goals: "Stay fit",
        workout_schedule: "Monday=09:00-10:00|Wednesday=14:00-15:00",
        gender_preferences: [ "Male", "Female" ],
        workout_types: [ "Cardio", "Strength" ],
        gym_locations: [ "Gym A", "Gym B" ],
        activities_with_experience: [ "Running:Intermediate", "Swimming:Beginner" ]
      }
    end

    it "creates a new fitness profile" do
      expect {
        post :create, params: { user_id: user.id, fitness_profile: valid_attributes }
      }.to change(FitnessProfile, :count).by(1)
    end

    it "redirects to the fitness profile show page" do
      post :create, params: { user_id: user.id, fitness_profile: valid_attributes }
      expect(response).to redirect_to(user_fitness_profile_path(user))
    end
  end

  describe "GET #show" do
    it "assigns the requested fitness profile to @fitness_profile" do
      get :show, params: { user_id: user.id, id: fitness_profile.id }
      expect(assigns(:fitness_profile)).to eq(fitness_profile)
    end
  end

  describe "GET #edit" do
    it "assigns the requested fitness profile to @fitness_profile" do
      get :edit, params: { user_id: user.id, id: fitness_profile.id }
      expect(assigns(:fitness_profile)).to eq(fitness_profile)
    end
  end

  describe "PATCH #update" do
    let(:new_attributes) do
      {
        age_range_start: 25,
        age_range_end: 35,
        fitness_goals: "Build muscle",
        workout_schedule: "Tuesday=10:00-11:00|Thursday=16:00-17:00",
        gender_preferences: [ "Female" ],
        workout_types: [ "Strength" ],
        gym_locations: [ "Gym C" ],
        activities_with_experience: [ "Weightlifting:Advanced" ]
      }
    end

    it "updates the requested fitness profile" do
      patch :update, params: { user_id: user.id, id: fitness_profile.id, fitness_profile: new_attributes }
      fitness_profile.reload
      expect(fitness_profile.age_range_start).to eq(25)
      expect(fitness_profile.age_range_end).to eq(35)
      expect(fitness_profile.fitness_goals).to eq("Build muscle")
      expect(fitness_profile.workout_schedule).to eq("Tuesday=10:00-11:00|Thursday=16:00-17:00")
      expect(fitness_profile.gender_preferences).to eq("Female")
      expect(fitness_profile.workout_types).to eq("Strength")
      expect(fitness_profile.gym_locations).to eq("Gym C")
      expect(fitness_profile.activities_with_experience).to eq("Weightlifting:Advanced")
    end

    it "redirects to the fitness profile show page" do
      patch :update, params: { user_id: user.id, id: fitness_profile.id, fitness_profile: new_attributes }
      expect(response).to redirect_to(user_fitness_profile_path(user))
    end
  end
end
