class CreateBook < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.boolean :read, default: false
    end
  end
end
