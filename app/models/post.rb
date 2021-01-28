class Post < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { minimum: 10 }
end
