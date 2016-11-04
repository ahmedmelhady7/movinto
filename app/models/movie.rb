class Movie < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  
  validates :name, :released_at, presence: true
end
