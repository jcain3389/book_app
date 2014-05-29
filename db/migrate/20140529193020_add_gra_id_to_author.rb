class AddGraIdToAuthor < ActiveRecord::Migration
  def change
    add_column :authors, :gra_id, :integer
  end
end
