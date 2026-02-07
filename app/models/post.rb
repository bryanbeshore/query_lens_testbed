class Post < ApplicationRecord
  enum :status, { draft: 0, published: 1, archived: 2 }

  belongs_to :user
  belongs_to :team
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
end
