class PagesController < ApplicationController

  def amazon
    @products = from_amazon(params[:amazon][:url])
    respond_to do |format|
      if @products.count > 1
        format.html { redirect_to "/products", notice: 'Products were successfully gathered.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { redirect_to :back, notice: 'Failed to gather information.' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
end
