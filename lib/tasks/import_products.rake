namespace :products do
  namespace :import do
    desc 'Import all products from CSV (sync)'
    task csv: :environment do
      file_path = Rails.root.join('data', 'MOCK_DATA.csv')
      CSVReaderService.new(file_path).sync(Product) do |configuration|
        configuration.column_target['product_name']     = :name
        configuration.column_target['barcode']          = :barcode
        configuration.column_target['photo_url']        = :photo_url
        configuration.column_target['price_cents']      = :price_cents
        configuration.column_target['sku (unique id)']  = :sku
        configuration.column_target['producer']         = :producer
        configuration.identify_by = :sku
      end
    end
  end
end
