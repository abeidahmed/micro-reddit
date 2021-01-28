class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :vote, null: false, default: 0
      t.references :votable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
