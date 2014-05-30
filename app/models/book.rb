class Book < ActiveRecord::Base
  has_many :bsaves
  has_many :users, through: :bsaves

  validates :title, presence: true
  validates :author, presence: true
  validates :grb_id, presence: true
end
