class CreateJoinTableWishlistMovie < ActiveRecord::Migration
  def change
    create_join_table :Wishlists, :Movies do |t|
      # t.index [:wishlist_id, :movie_id]
      # t.index [:movie_id, :wishlist_id]
    end
  end
end
