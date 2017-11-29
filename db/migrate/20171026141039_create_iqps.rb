class CreateIqps < ActiveRecord::Migration[5.1]
  def change
    create_table :iqps do |t|
      t.string :item
      t.integer :quantity
      t.references :slist, foreign_key: true

      t.timestamps
    end
  end
end
