class Post < ApplicationRecord
  include Votable

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { minimum: 10 }
end
