class AddGrbidToBook < ActiveRecord::Migration
  def change
    add_column :books, :grb_id, :integer
  end
end
