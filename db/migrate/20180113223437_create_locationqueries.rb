class CreateLocationqueries < ActiveRecord::Migration[5.1]
  def change
    create_table :locationqueries do |t|
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
