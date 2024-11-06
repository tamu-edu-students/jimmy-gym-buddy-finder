class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :omniauth, :failure ]
  skip_before_action :check_profile_completion

  def logout
    reset_session
    redirect_to welcome_path, notice: "You are logged out."
  end

  # GET /auth/google_oauth2/callback
  def omniauth
    auth = request.env["omniauth.auth"]
    @user = find_or_create_user(auth)

    session[:user_id] = @user.id
    redirect_based_on_profile_completeness
  end

  def failure
    redirect_to welcome_path, alert: "Authentication failed. Please try again or contact support."
  end

  private

  def find_or_create_user(auth)
    User.find_by(uid: auth["uid"], provider: auth["provider"]) || create_user(auth)
  end

  def create_user(auth)
    names = auth["info"]["name"].split
    user = User.create(
      uid: auth["uid"],
      provider: auth["provider"],
      email: auth["info"]["email"],
      first_name: names[0],
      last_name: names[1..].join(" ")
    )

    UserMatchJob.perform_later(user) if user.persisted?
    user
  end

  def redirect_based_on_profile_completeness
    if @user.valid?(:profile_update)
      redirect_to dashboard_user_path(@user), notice: "You are logged in and your profile is complete."
    else
      redirect_to edit_user_path(@user), alert: "Please complete your profile information."
    end
  end
end
