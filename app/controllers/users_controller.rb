class UsersController < ApplicationController
    def new
      @user = User.new # Initializes a new user instance for the form
    end
  
    def create
      @user = User.new(user_params) # Create a new user with the submitted params
  
      if @user.save
        flash[:notice] = 'User registered successfully.'
        redirect_to new_user_path
      else
        flash.now[:alert] = 'There were errors while saving the user.' # Correctly using flash.now
        render :new # This re-renders the new form
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :age, :gender) # Strong parameters to prevent mass assignment issues
    end
  end
  