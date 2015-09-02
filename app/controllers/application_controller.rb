class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def from_amazon(url)
    begin

      agent = Mechanize.new

      agent = TorPrivoxy::Agent.new '127.0.0.1', '', {8118 => 9051} do |agent|
        sleep 1
      #  logger.debug "New IP is #{agent.ip}------------------------------------------------===================================================="
      #  logger.info "New IP is #{agent.ip}------------------------------------------------===================================================="
      end

      agent.user_agent_alias = "Mac Safari 4"
      #page = agent.get('http://www.amazon.in/s/ref=nb_sb_noss_1/278-0803572-2415314?url=search-alias%3Daps&field-keywords=royal+canin')
      #page = agent.get('http://www.amazon.in/s/ref=nb_sb_noss_2/277-7862435-2981953?url=search-alias%3Daps&field-keywords=bajaj&rh=i%3Aaps%2Ck%3Abajaj')

      hostname = URI.parse(url).host
      key = Base64.strict_encode64(url)

      if hostname.match("amazon.com")

      else
        Product.where(:source => key).destroy_all

        page = agent.get(url)
      #  logger.info "New IP is #{agent.ip}------------------------------------------------===================================================="

        iterate_products(agent, page.search("li.s-result-item"), url)

        loop do
          if link = page.link_with(:dom_id => "pagnNextLink") # As long as there is still a nextpage link...
            page = link.click
          else # If no link left, then break out of loop
            break
          end

          iterate_products(agent, page.search("li.s-result-item"), url)
        end
      end
    rescue => e
      puts "Pochu da..."
      puts e
      puts e.backtrace
    end

    Product.where(:source => key)
  end
end

def iterate_products(agent, products_list, url)
  key = Base64.strict_encode64(url)
  products_list.each_with_index do |item, i|
    begin
      product = Product.new
      #puts "Product No: #{i} ##################################"

      product.link = item.search("a.s-access-detail-page").attr("href")
      product_page = agent.get(product.link)
      #logger.info "New IP is #{agent.ip}------------------------------------------------===================================================="

      #puts item.search("a.s-access-detail-page").attr("href")
      product.name = product_page.search("#productTitle").text
      #puts item.search("h2").text
      product.price = product_page.search("#priceblock_ourprice").text
      #puts item.search("span.s-price").text
      product.model = product_page.search("#feature-bullets").search("li").text
      product.sale = product_page.search("#priceblock_saleprice").text
      #puts item.search("img.s-access-image").attr("src")
      product.asin = item.attr("data-asin")
      #puts item.attr("data-asin")
      product.mrp = item.search("span.a-text-strike").text
      #puts item.search("span.a-text-strike").text
      product.source = key
      product.save!
    rescue e
      puts e
      puts e.backtrace
    end
  end
end
