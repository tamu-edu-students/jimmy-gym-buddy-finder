class NotificationsController < ApplicationController
    before_action :authenticate_user!  # Ensure user is logged in
  
    def index
      notifications = current_user.notifications.order(created_at: :desc)
      render json: notifications, status: :ok
    end
  
    def mark_as_read
      notification = current_user.notifications.find(params[:id])
      notification.update(read: true)
  
      render json: { message: 'Notification marked as read.' }, status: :ok
    end
  end
  