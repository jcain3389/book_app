class Asave < ActiveRecord::Base
  belongs_to :user
  belongs_to :author
end
