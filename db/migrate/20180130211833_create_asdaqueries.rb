class CreateAsdaqueries < ActiveRecord::Migration[5.1]
  def change
    create_table :asdaqueries do |t|
      t.string :query

      t.timestamps
    end
  end
end
