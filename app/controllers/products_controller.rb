class ProductsController < ApplicationController
  DEFAULT_PAGE_SIZE = 10

  def index
    # here should go security stuff
    products = Product.all
                      .page(params[:page] || 1)
                      .per(params[:per_page] || DEFAULT_PAGE_SIZE)
    render jsonapi: products
  end
end
