class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.boolean :is_featured, default: false
      t.date :released_at
      t.integer :average_rating, default: 0
      
      t.timestamps null: false
    end
  end
end
