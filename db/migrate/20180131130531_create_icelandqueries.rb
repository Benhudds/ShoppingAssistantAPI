class CreateIcelandqueries < ActiveRecord::Migration[5.1]
  def change
    create_table :icelandqueries do |t|
      t.string :query

      t.timestamps
    end
  end
end
