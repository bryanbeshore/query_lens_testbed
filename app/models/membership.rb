class Membership < ApplicationRecord
  enum :role, { member: 0, admin: 1, owner: 2 }

  belongs_to :user
  belongs_to :team
end
