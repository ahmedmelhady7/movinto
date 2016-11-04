class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  
  validates :content, :rating, presence: true
end
