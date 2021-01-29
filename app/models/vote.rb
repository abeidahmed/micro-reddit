class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, counter_cache: :votes_count
end
