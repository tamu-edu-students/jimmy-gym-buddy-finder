class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :check_profile_completion

  private

  def user
    # if @current _user is undefined or falsy, evaluate the RHS
    #   RHS := look up user by id only if user id is in the session hash
    # question: what happens if session has user_id but DB does not?
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # user returns @user,
    #   which is not nil (truthy) only if session[:user_id] is a valid user id
    user.present?
  end

  def check_profile_completion
    if logged_in? && !@user.valid?(:profile_update)
      redirect_to edit_user_path(@user), alert: 'Please complete your profile information before accessing other sections.'
    end
  end

  def require_login
    # redirect to the welcome page unless user is logged in
    unless logged_in?
      redirect_to welcome_path, alert: 'You must be logged in to access this section.'
    end
  end
end
