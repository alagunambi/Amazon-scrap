class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :price
      t.text :model
      t.string :asin
      t.string :mrp
      t.string :sale
      t.text :link
      t.text :source

      t.timestamps null: false
    end
  end
end
