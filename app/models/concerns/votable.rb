module Votable
  def upvote
    votes.create!
  end

  def downvote(id)
    votes.find(id).destroy
  end
end
