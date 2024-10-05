class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, presence: true, on: :default
  validates :username, presence: true, format: { with: /\A[a-zA-Z\s]+\z/, message: "only allows letters" }, length: { minimum: 3 }, on: :profile_update
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 16 }, on: :profile_update
  validates :gender, presence: true, on: :profile_update
  has_one_attached :photo

  def password_required?
    uid.blank? && provider.blank? && super
  end
end
