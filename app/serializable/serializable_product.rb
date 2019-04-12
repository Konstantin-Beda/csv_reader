class SerializableProduct < JSONAPI::Serializable::Resource
  type 'products'
  attribute :name
  attribute :barcode
  attribute :photo_url
  attribute :price_cents
  attribute :sku
  attribute :producer
end
