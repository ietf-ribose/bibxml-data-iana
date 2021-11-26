require 'net/http'
require 'json'

page = 1
uri = URI "https://api.github.com/search/code?q=<registry+repo:ietf-ribose/iana-registries+extension:xml&page=#{page}"
resp = Net::HTTP.get uri
json = JSON.parse resp
puts json.keys
