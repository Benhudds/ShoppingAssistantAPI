class Addimageurl < ActiveRecord::Migration[5.1]
  def change
    add_column :ipls, :imageurl, :string
  end
end
