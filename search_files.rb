require 'net/http'
require 'json'

def fetch(page = 1)
  uri = URI "https://api.github.com/search/code?q=<registry+repo:ietf-ribose/iana-registries+extension:xml&page=#{page}"
  # headers = { 'Authorization' => "token #{ENV['GITHUB_TOKEN']}" }
  req = Net::HTTP::Get.new uri
  req['authorization'] = "Bearer #{ENV['GITHUB_TOKEN']}" if ENV['GITHUB_TOKEN']
  attempt = 0
  json = {}
  until attempt > 3 || json['items']
    sleep 1 if attempt > 0
    attempt += 1
    resp = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request req
    end
    json = JSON.parse resp.body
    puts "Retry-After: #{resp['Retry-After']}" if resp['Retry-After']
    puts "Page: #{page}; message: #{json['message']}; documentation_url: #{json['documentation_url']}"
  end
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

uri_lim = URI "https://api.github.com/rate_limit"
req_lim = Net::HTTP::Get.new uri_lim
req_lim['authorization'] = "Bearer #{ENV['GITHUB_TOKEN']}" if ENV['GITHUB_TOKEN']
resp_lim = Net::HTTP.start(uri_lim.host, uri_lim.port, :use_ssl => uri_lim.scheme == 'https') do |http|
  http.request(req_lim)
end
puts "Rate limit: #{resp_lim.body}"

fetch
