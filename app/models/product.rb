class Product < ActiveRecord::Base

  def self.as_csv
    CSV.generate do |csv|
      csv << ['name', 'link', 'asin', 'model', 'sale', 'mrp', 'price', 'source' ]
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end
end
