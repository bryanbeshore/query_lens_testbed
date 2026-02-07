class User < ApplicationRecord
  enum :role, { member: 0, admin: 1 }

  has_many :memberships, dependent: :destroy
  has_many :teams, through: :memberships
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
