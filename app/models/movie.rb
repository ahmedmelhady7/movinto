class Movie < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :categorizations
  has_many :genres, :through => :categorizations
  has_and_belongs_to_many :actors
  has_and_belongs_to_many :wishlists
  belongs_to :director
  
  validates :name, :released_at, :director_id, presence: true
end