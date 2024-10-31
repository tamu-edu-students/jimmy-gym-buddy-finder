class NotificationsController < ApplicationController
    before_action :require_login
  
    def index
      notifications = user.notifications.order(created_at: :desc)
      render json: notifications, status: :ok
    end

    def mark_as_read
      begin
        notification = user.notifications.find(params[:id])
        if notification.update(read: true)
          respond_to do |format|
            format.json { render json: { message: 'Notification marked as read.', status: :ok, read: true } }
          end
        else
          render json: { message: 'Failed to mark notification as read.' }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Notification not found.' }, status: :not_found
      end
    end
    
    def mark_as_unread
      begin
        notification = user.notifications.find(params[:id])
        if notification.update(read: false)
          respond_to do |format|
            format.json { render json: { message: 'Notification marked as unread.', status: :ok, read: false } }
          end
        else
          render json: { message: 'Failed to mark notification as unread.' }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Notification not found.' }, status: :not_found
      end
    end
  end
  