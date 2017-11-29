class CreateIpls < ActiveRecord::Migration[5.1]
  def change
    create_table :ipls do |t|
      t.float :price
      t.string :name
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
