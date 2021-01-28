class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false, default: ''
      t.text :content, default: ''
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
