class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  encrypts :content

  validates :content, presence: true
end
