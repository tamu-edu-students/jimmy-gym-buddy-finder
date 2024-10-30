class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :matched_user, class_name: 'User'

  scope :new_notifications, -> { where(read: false) }
  scope :old_notifications, -> { where(read: true) }

  def matched_user_name
    matched_user.username
  end
end
