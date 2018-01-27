class ModifyIpls < ActiveRecord::Migration[5.1]
  def change
    add_column :ipls, :measure, :string
    add_column :ipls, :quantity, :float
    rename_column :ipls, :name, :item
  end
end
