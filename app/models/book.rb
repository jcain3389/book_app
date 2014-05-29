class Book < ActiveRecord::Base
  has_many :bsaves
  has_many :users, through: :bsaves
end
