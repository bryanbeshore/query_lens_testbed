class Invoice < ApplicationRecord
  enum :status, { pending: 0, paid: 1, overdue: 2 }

  belongs_to :team
end
