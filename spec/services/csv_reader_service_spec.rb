require 'rails_helper'

describe CSVReaderService do
  let(:csv_path) { Rails.root.join('spec', 'fixtures', 'MOCK_DATA.csv') }
  let(:csv_records_count) { 9 }

  describe '#sync' do
    let(:sync_subject) { Product }
    subject do
      described_class.new(csv_path).sync(sync_subject) do |configuration|
        configuration.column_target['product_name'] = 'name'
        configuration.column_target['barcode'] = 'barcode'
        configuration.column_target['photo_url'] = 'photo_url'
        configuration.column_target['price_cents'] = 'price_cents'
        configuration.column_target['sku (unique id)'] = 'sku'
        configuration.column_target['producer'] = 'producer'
        configuration.identify_by = 'sku'
        configuration.logger = Logger.new('/dev/null')
      end
    end

    context 'when no same records in table' do
      it 'inserts records to table' do
        expect { subject }.to change(sync_subject, :count).by(csv_records_count)
      end
    end

    context 'when some records exists' do
      let(:sku) { '4648a782-69ce-4b9b-b109-ecf80906b74b' }
      let(:attributes) do
        {
          name: 'Chocolate - Feathers',
          photo_url: 'http://dummyimage.com/189x206.jpg/5fa2dd/ffffff',
          barcode: '9751',
          price_cents: 7963,
          producer: 'Abbott LLC',
          sku: sku
        }
      end

      context 'when data need to be updated' do
        let(:stale_record) { sync_subject.find_by(sku: sku) }

        before { create :product, sku: sku }

        it 'updates existent records and inserts new' do
          expect { subject }.to change(sync_subject, :count).by(csv_records_count - 1)
          attributes.each do |attribute, value|
            expect(stale_record.send(attribute)).to eq(value)
          end
        end
      end

      context 'when CSV doesn`t contain fresh data' do
        let!(:stale_record) { create :product, attributes }

        it 'doesn`t update stale_record' do
          expect { subject }.not_to change { Product.find_by(sku: sku).updated_at }
        end
      end
    end
  end
end
