require 'uri'
require 'net/https'
require 'benchmark'

def http_request(url)
  begin
    uri = URI.parse(url)
    valid = uri.is_a?(URI::HTTP) && !uri.host.nil?
    raise URI::InvalidURIError if !valid

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = nil
    time = Benchmark.realtime do
       response = http.request request
    end

    puts "Request Time: #{time}"    # Write the HTTP Response Time into log
    puts "Status: #{response.code}" # Write the Response Status into log

    time_minutes = time / 60
    puts time_minutes
    (time_minutes > 5) ? time : nil
  rescue URI::InvalidURIError => e
    puts "Invalid URL:"
    puts e.message
    nil
  rescue Exception => e
    puts e.message
    nil
  end
end

puts "Requesting to URL '#{ARGV[0]}'"
puts http_request ARGV[0]
