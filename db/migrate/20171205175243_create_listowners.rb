class CreateListowners < ActiveRecord::Migration[5.1]
  def change
    create_table :listowners do |t|
      t.references :slist, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
