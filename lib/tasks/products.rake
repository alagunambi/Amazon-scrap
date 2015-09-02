namespace :products do
  task :from_amazon_in => :environment do
    agent = Mechanize.new
    #page = agent.get('http://www.amazon.in/s/ref=nb_sb_noss_1/278-0803572-2415314?url=search-alias%3Daps&field-keywords=royal+canin')
    #page = agent.get('http://www.amazon.in/s/ref=nb_sb_noss_2/277-7862435-2981953?url=search-alias%3Daps&field-keywords=bajaj&rh=i%3Aaps%2Ck%3Abajaj')
    page = agent.get('http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=bajaj')
    #page = agent.get(url)

    iterate_products(page.search("li.s-result-item"))

    loop do
      if link = page.link_with(:dom_id => "pagnNextLink") # As long as there is still a nextpage link...
        page = link.click
      else # If no link left, then break out of loop
        break
      end

      iterate_products(page.search("li.s-result-item"))
    end

    puts Product.count.to_s
  end

  task :clean => :environment do
    Product.destroy_all
  end
end

def iterate_products(products_list)
  products_list.each_with_index do |item, i|
    product = Product.new
    #puts "Product No: #{i} ##################################"
    product.link = item.search("a.s-access-detail-page").attr("href")
    puts item.search("a.s-access-detail-page").attr("href")
    product.name = item.search("h2").text
    puts item.search("h2").text
    product.price = item.search("span.s-price").text
    puts item.search("span.s-price").text
    product.model = item.search("img.s-access-image").attr("src")
    puts item.search("img.s-access-image").attr("src")
    product.asin = item.attr("data-asin")
    puts item.attr("data-asin")
    product.mrp = item.search("span.a-text-strike").text
    puts item.search("span.a-text-strike").text
    #product.source = url
    product.save!
  end
end
