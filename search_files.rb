require 'net/http'
require 'json'

page = 1
uri = URI "https://api.github.com/search/code?q=<registry+repo:ietf-ribose/iana-registries+extension:xml&page=#{page}"
resp = Net::HTTP.get uri
json = JSON.parse resp
puts "Items: #{json['items'].size}"
puts "total_count: #{json['total_count']}"
puts "incomplete_results: #{json['incomplete_results']}"
