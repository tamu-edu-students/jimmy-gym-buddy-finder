class User < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  validates :name, :age, :gender, presence: true
end
