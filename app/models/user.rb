class User < ApplicationRecord
    validates :name, presence: true
    validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :gender, presence: true
  end
