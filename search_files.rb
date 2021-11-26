require 'net/http'
require 'json'

def fetch(page = 1)
  uri = URI "https://api.github.com/search/code?q=<registry+repo:ietf-ribose/iana-registries+extension:xml&page=#{page}"
  # headers = { 'Authorization' => "token #{ENV['GITHUB_TOKEN']}" }
  req = Net::HTTP::Get.new uri
  req['authorization'] = "Bearer #{ENV['GITHUB_TOKEN']}" if ENV['GITHUB_TOKEN']
  resp = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request req
  end
  json = JSON.parse resp.body
  puts "Retry-After: #{resp['Retry-After']}" if resp['Retry-After']
  puts resp.to_hash
  puts "Page: #{page}; message: #{json['message']}; documentation_url: #{json['documentation_url']}"
  # puts json.keys
  # puts "items_number: #{json['items'].size}"
  # puts "total_count: #{json['total_count']}"
  # puts "incomplete_results: #{json['incomplete_results']}"
  # puts 'Items:'
  # json['items'].each do |item|
  #   puts item['name']
  # end
  if (json['total_count'].to_i - (page * 30)).positive?
    sleep 1
    fetch(page + 1)
  end
end

fetch
