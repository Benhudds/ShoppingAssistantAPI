class CreateIqps < ActiveRecord::Migration[5.1]
  def change
    create_table :iqps do |t|
      t.string :item
      t.float :quantity
      t.string :measure
      t.references :slist, foreign_key: true

      t.timestamps
    end
  end
end
