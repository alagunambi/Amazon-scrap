class Product < ActiveRecord::Base

  def self.as_csv
    CSV.generate do |csv|
      csv << ['name', 'link', 'asin', 'model', 'sale', 'mrp', 'price', 'source' ]
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  def self.random_desktop_user_agent
    user_agents = [
      'Windows IE 6',
      'Windows IE 7',
      'Windows Mozilla',
      'Mac Safari',
      'Mac FireFox',
      'Mac Mozilla',
      'Linux Mozilla',
      'Linux Firefox',
      'Linux Konqueror',
      'iPhone']
   return user_agents.sample
  end
end
