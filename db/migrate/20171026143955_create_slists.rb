class CreateSlists < ActiveRecord::Migration[5.1]
  def change
    create_table :slists do |t|
      t.string :name
      t.timestamps
    end
  end
end
