class CreateJoinTableActorMovie < ActiveRecord::Migration
  def change
    create_join_table :Actors, :Movies do |t|
      # t.index [:actor_id, :movie_id]
      # t.index [:movie_id, :actor_id]
    end
  end
end
