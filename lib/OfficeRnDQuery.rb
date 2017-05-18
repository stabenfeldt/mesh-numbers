# encoding: ascii-8bit

class OfficeRnDQuery
  #require 'HTTParty'
  #include HTTParty

  def initialize
    require 'json'
    require 'ostruct'
	  puts "OfficeRndQuery loaded"
  end

  def self.total
    @auth = ENV['OFFICE_RND_TOKEN']
    url = 'https://app.officernd.com/api/v1/organizations/mesh-oslo/members/'
    puts "Auth is #{@auth}"
    puts "URL: #{url}"

    response = HTTParty.get(url, :headers => { "Authorization" => @auth})
    throw "Failed to query Office RnD: #{response}. Auth: #{@auth}" \
      unless response.success?

    members  = JSON.parse(response.body, object_class: OpenStruct)
    total    = members.select{ |m| m.status == 'active' }.size rescue 0
    return total
  end

end
