class CreateTescoqueries < ActiveRecord::Migration[5.1]
  def change
    create_table :tescoqueries do |t|
      t.string :query

      t.timestamps
    end
  end
end
