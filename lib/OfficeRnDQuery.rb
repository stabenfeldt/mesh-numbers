class OfficeRndQuery

  def initialize
    require 'json'
    require 'ostruct'
    @auth = ENV['OFFICE_RND_TOKEN']
  end

  def self.total
    url = 'https://app.officernd.com/api/v1/organizations/mesh-oslo/members/'

    unless member_count
      data         = HTTParty.get(url, :headers => { "Authorization" => @auth}) rescue 'failed'
      render text: data
      json         = data.to_json
      members      = JSON.parse(json, object_class: OpenStruct)
      total        = members.select{ |m| m.status == 'active' }.size rescue 0
      result  = { time: time,
                  count: total,
                  last_count: last_count}
      return result
    end
  end

end
