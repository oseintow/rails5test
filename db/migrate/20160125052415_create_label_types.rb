class CreateLabelTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :label_types do |t|
      t.string :name
      t.references :label, index: true, foreign_key: true

      t.timestamps
    end
  end
end
