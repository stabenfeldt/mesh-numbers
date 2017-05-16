class MembersController < ApplicationController
  def initialize
    require 'json'
    require 'ostruct'
    @auth = ENV['OFFICE_RND_TOKEN']
  end

  def total
    url = 'https://app.officernd.com/api/v1/organizations/mesh-oslo/members/'

    # 1. check if we have data for today
    member_count =  MemberCount.where("created_at >= ?", Time.zone.now.beginning_of_day).first
    unless member_count
      data         = HTTParty.get(url, :headers => { "Authorization" => @auth})
      json         = data.to_json
      members      = JSON.parse(json, object_class: OpenStruct)
      total        = members.select{ |m| m.status == 'active' }.size rescue 0

      MemberCount.create!(kind: 'total', count: total)
    end
    member_count = MemberCount.last.count           rescue 0
    time         = MemberCount.last.created_at      rescue 0
    last_count   = MemberCount.second_latest.count  rescue 0

    result  = { time: time,
                count: member_count,
                last_count: last_count}
    render json: result
  end

  def worklounge
  end

  def fixed
  end

  def flex
  end
end
