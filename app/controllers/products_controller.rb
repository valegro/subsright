class ProductsController < InheritedResources::Base
  respond_to :html, :json, :xml

  def index
    @products = Product.where('stock IS NULL OR stock > 0').order('stock DESC', :name)
  end
end
