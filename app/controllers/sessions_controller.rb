class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:omniauth, :failure]
  skip_before_action :check_profile_completion



  def logout
    reset_session
    redirect_to welcome_path, notice: 'You are logged out.'
  end

  # GET /auth/google_oauth2/callback
  def omniauth
    if params[:error]
      redirect_to failure_path, alert: "You have denied access. Please try again or use a different account."
      return
    end

    auth = request.env['omniauth.auth']
    @user = User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.email = auth['info']['email']
      names = auth['info']['name'].split
      u.first_name = names[0]
      u.last_name = names[1..].join(' ')
    end

    if @user.persisted?
      session[:user_id] = @user.id
      if @user.valid?(:profile_update)
        redirect_to dashboard_user_path(@user), notice: 'You are logged in and your profile is complete.'
      else
        redirect_to edit_user_path(@user), alert: 'Please complete your profile information.'
      end
    else
      redirect_to welcome_path, alert: 'Login failed. Please try again.'
    end
  end

  def failure
    redirect_to welcome_path, alert: 'Authentication failed. Please try again or contact support.'
  end

end
