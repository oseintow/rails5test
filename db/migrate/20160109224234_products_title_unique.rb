class ProductsTitleUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :products, :title, :unique => true
  end
end
