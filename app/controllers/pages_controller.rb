class PagesController < ApplicationController

  def amazon_redirect
    @key = Base64.strict_encode64(params[:amazon][:url])
    @params = params[:amazon]

    #redirect_to :controller => "pages", :action => "amazon", :amazon => params[:amazon]
  end

  def amazon
    @products = from_amazon(params[:amazon][:url])
    key = Base64.strict_encode64(params[:amazon][:url])
    respond_to do |format|
      if @products.count > 1
        format.html { redirect_to "/products?key=#{key}", notice: 'Products were successfully gathered.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { redirect_to "/", notice: 'Failed to gather information.' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
end
