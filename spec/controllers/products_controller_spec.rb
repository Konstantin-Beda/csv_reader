require 'rails_helper'

describe ProductsController, type: :controller do
  describe 'GET /products' do
    let(:params) { {} }

    subject { get :index, params: params }

    context 'when there are no products' do
      it 'respond with empty array' do
        subject
        expect_json_types(data: :array)
        expect_json_sizes(data: 0)
      end
    end

    context 'when products are exist' do
      before { create_list :product, 20 }

      context 'when no :per_page given' do
        it 'terurns DEFAULT_PAGE_SIZE items' do
          subject
          expect_json_types(data: :array)
          expect_json_sizes(data: described_class::DEFAULT_PAGE_SIZE)
        end
      end

      context 'when :per_page given' do
        let!(:per_page)  { rand(described_class::DEFAULT_PAGE_SIZE) }
        let!(:params)    { { per_page: per_page } }

        it 'terurns requested items number' do
          subject
          expect_json_types(data: :array)
          expect_json_sizes(data: per_page)
        end
      end
    end
  end
end
