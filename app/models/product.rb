class Product < ActiveRecord::Base

  def self.as_csv
    col_names = 'name,asin,price,mrp,sale,model,link,source'
    col_names = col_names.split(",") if  col_names.is_a?(String)
    CSV.generate(:col_sep => ",") do |csv|
      csv << col_names
      all.each do |item|
        csv << col_names.collect{|name| item.send(name).squish()}
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
