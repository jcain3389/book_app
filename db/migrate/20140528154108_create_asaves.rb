class CreateAsaves < ActiveRecord::Migration
  def change
    create_table :asaves do |t|
      t.references :user
      t.references :author
    end
  end
end
