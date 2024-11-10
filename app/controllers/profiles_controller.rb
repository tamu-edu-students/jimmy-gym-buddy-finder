class ProfilesController < ApplicationController
    def show
        @user = User.find(params[:id])
    end

    def create_chat
        @selected_profile = Profile.find(params[:id])
        profile1_id = current_profile.id
        profile2_id = @selected_profile.id

        if current_profile == @selected_profile
          flash[:alert] = "You cannot send a message to yourself."
          redirect_to profile_path(@selected_profile) and return
        end

        @private_chat = PrivateChat.get_private_chat(profile1_id, profile2_id)

        unless @private_chat
          @private_chat = PrivateChat.create(profile1: current_profile, profile2: @selected_profile)
        end

        redirect_to profile_private_chat_path(current_profile, @private_chat)
      end
end
