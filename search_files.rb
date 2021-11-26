require 'net/http'
require 'json'

def fetch(page = 1)
  uri = URI "https://api.github.com/search/code?q=<registry+repo:ietf-ribose/iana-registries+extension:xml&page=#{page}"
  resp = Net::HTTP.get uri, headers: { 'Authorization' => "token #{ENV['GITHUB_TOKEN']}" }
  json = JSON.parse resp
  puts "Page: #{page}; message: #{json['message']}; documentation_url: #{json['documentation_url']}"
  # puts json.keys
  # puts "items_number: #{json['items'].size}"
  # puts "total_count: #{json['total_count']}"
  # puts "incomplete_results: #{json['incomplete_results']}"
  # puts 'Items:'
  # json['items'].each do |item|
  #   puts item['name']
  # end
  fetch(page + 1) if (json['total_count'].to_i - (page * 30)).positive?
end

puts "Token: #{ENV['GITHUB_TOKEN']}"
fetch
