class AddMeasureToIqps < ActiveRecord::Migration[5.1]
  def change
    add_column :iqps, :measure, :string
  end
end
