class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :barcode
      t.string :photo_url
      t.integer :price_cents
      t.string :sku, index: { unique: true }, limit: 40
      t.string :producer

      t.timestamps
    end
  end
end
