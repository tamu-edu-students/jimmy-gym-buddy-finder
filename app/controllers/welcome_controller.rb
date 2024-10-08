class WelcomeController < ApplicationController
  skip_before_action :require_login, only: [ :index ]

  def index
    if logged_in?
      redirect_to dashboard_user_path(@user), notice: "Welcome back!"
    end
  end
end
