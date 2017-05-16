class OfficeRndQuery
  def self.total
    url = 'https://app.officernd.com/api/v1/organizations/mesh-oslo/members/'

    member_count =  MemberCount.where("created_at >= ?", Time.zone.now.beginning_of_day).first
    unless member_count
      data         = HTTParty.get(url, :headers => { "Authorization" => @auth})
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
