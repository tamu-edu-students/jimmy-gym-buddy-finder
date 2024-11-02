class User < ApplicationRecord
  has_many :user_matches, dependent: :destroy
  has_one :fitness_profile, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, presence: true, on: :default
  validates :username, presence: true, format: { with: /\A[a-zA-Z\s]+\z/, message: "only allows letters" }, length: { minimum: 3 }, on: :profile_update
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 16 }, on: :profile_update
  validates :gender, presence: true, on: :profile_update
  validate :photo_type, :photo_size
  has_one_attached :photo
  has_one :fitness_profile, dependent: :destroy
  after_create :build_default_fitness_profile

  def build_default_fitness_profile
    build_fitness_profile.save
  end

  def password_required?
    uid.blank? && provider.blank? && super
  end

  def photo_type
    if photo.attached? && !photo.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:photo, "must be a JPEG, JPG, GIF, or PNG.")
    end
  end

  def photo_size
    if photo.attached? && photo.blob.byte_size > 500.kilobytes
      errors.add(:photo, "must be less than 500KB in size.")
    end
  end
end
