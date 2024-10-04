class User < ApplicationRecord
  validates :name, presence: true, format: { with: /\A[a-zA-Z\s]+\z/, message: "only allows letters" }, length: { minimum: 3 }
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 16 }
  validates :gender, presence: true
end
