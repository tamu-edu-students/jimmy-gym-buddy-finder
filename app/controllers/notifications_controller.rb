class NotificationsController < ApplicationController
    before_action :require_login
    before_action :load_notifications

    def index
      notifications = user.notifications.order(created_at: :desc)
      render json: notifications, status: :ok
    end

    def mark_as_read
      notification = user.notifications.find(params[:id])
      notification.update(read: true)
      
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("notification_#{notification.id}", partial: "notifications/notification", locals: { notification: notification })
        end
        format.html { redirect_to notifications_path, notice: "Notification updated." }
      end
    end

    def mark_as_unread
      notification = user.notifications.find(params[:id])
      notification.update(read: false)
    # render json: user.notifications, status: :ok
    #   if notification.update(read: false)
    #     #load_notifications
    #     respond_to do |format|
    #       format.json { render json: { id: notification.id, read: false } }
    #     end
    #   else
    #     render json: { message: 'Failed to mark notification as unread.' }, status: :unprocessable_entity
    #   end
    # end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("notification_#{notification.id}", partial: "notifications/notification", locals: { notification: notification })
      end
      format.html { redirect_to notifications_path, notice: "Notification updated." }
    end
  end
end
