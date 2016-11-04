class Genre < ActiveRecord::Base
  has_many :categorizations
  has_many :movies, :through => :categorizations
end