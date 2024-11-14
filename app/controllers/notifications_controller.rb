class NotificationsController < ApplicationController
    before_action :require_login
    before_action :load_notifications

    def index
      notifications = user.notifications.order(created_at: :desc)
      render json: notifications, status: :ok
    end

    def mark_as_read
      notification = user.notifications.find(params[:id])

      if notification.update(read: true)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("notification_#{notification.id}", partial: "notifications/notification", locals: { notification: notification })
          end
          format.html { redirect_to notifications_path, notice: "Notification updated." }
          format.json { render json: { id: notification.id, read: true }, status: :ok }
        end
      else
        render json: { message: "Failed to mark notification as read." }, status: :unprocessable_entity
      end
    end

    def mark_as_unread
      notification = user.notifications.find(params[:id])

      if notification.update(read: false)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("notification_#{notification.id}", partial: "notifications/notification", locals: { notification: notification })
          end
          format.html { redirect_to notifications_path, notice: "Notification updated." }
          format.json { render json: { id: notification.id, read: false }, status: :ok }
        end
      else
        render json: { message: "Failed to mark notification as unread." }, status: :unprocessable_entity
      end
    end
end
