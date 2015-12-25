class CreateLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :labels do |t|
      t.string :name
      t.integer :qty
      t.references :product_variant, index: true, foreign_key: true

      t.timestamps
    end
  end
end
