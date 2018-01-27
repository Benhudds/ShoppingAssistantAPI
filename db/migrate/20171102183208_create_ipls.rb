class CreateIpls < ActiveRecord::Migration[5.1]
  def change
    create_table :ipls do |t|
      t.float :price
      t.string :item
      t.float :quantity
      t.string :measure
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
