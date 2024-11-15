# app/models/conversation.rb
class Conversation < ApplicationRecord
  belongs_to :user1, class_name: "User", foreign_key: "user1_id"
  belongs_to :user2, class_name: "User", foreign_key: "user2_id"
  has_many :messages, dependent: :destroy

  validates :user1_id, uniqueness: { scope: :user2_id }

  scope :between, ->(user1_id, user2_id) do
    where("(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
          user1_id, user2_id, user2_id, user1_id)
  end
end
