class CreateBsaves < ActiveRecord::Migration
  def change
    create_table :bsaves do |t|
      t.references :user
      t.references :book
    end
  end
end
