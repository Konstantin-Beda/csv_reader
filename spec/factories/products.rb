FactoryBot.define do
  factory :product do
    name        { Faker::Beer.name }
    barcode     { Faker::Code.ean }
    photo_url   { Faker::Internet.url }
    price_cents { rand(100...100_000) }
    sku         { Faker::Lorem.characters(37) }
    producer    { Faker::Beer.brand }
  end
end
