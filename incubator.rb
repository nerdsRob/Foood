require 'nokogiri'
require 'open-uri'
require 'htmlentities'
require 'sinatra'
require 'json'

url 	= 'http://www.studentenwerk-berlin.de/speiseplan/rss/htw_wilhelminenhof/tag/kurz/8'
coder 	= HTMLEntities.new
feed	= Nokogiri::HTML(open(url)) 
food 	= Nokogiri::XML(coder.decode(feed))
hash	= Hash.new { |h,k| h[k] = [] }

# Parse feed
food.css('td.mensa_day_speise_name').each do |data|
	title = data.content.tr('0-9', '').strip
	hash[:titles] << title
end	

# Parse feed
food.css('td.mensa_day_speise_preis').each do |data|
	price = data.content.tr('A-Za-z', '').strip
	hash[:prices] << price
end	

# REST
get '/food' do
 	content_type :json, 'charset' => 'utf-8'
   	hash.to_json
end