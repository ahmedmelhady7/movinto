class Movie < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :categorizations
  has_many :genres, :through => :categorizations
  has_and_belongs_to_many :actors
  
  validates :name, :released_at, presence: true
end