class Author < ActiveRecord::Base
  has_many :asaves
  has_many :users, through: :asaves

  validates :name, presence: true
  validates :gra_id, presence: true
end
