class MembersController < ApplicationController
  require 'OfficeRnDQuery'

  def total

    # 1. check if we have data for today
    member_count =  MemberCount.where("created_at >= ?", Time.zone.now.beginning_of_day).first

    MemberCount.create!(kind: 'total', count: OfficeRnDQuery.total)
    member_count    = MemberCount.last.count           rescue 0
    time            = MemberCount.last.created_at      rescue 0
    previous_count  = MemberCount.second_latest.count  rescue 0

    result  = { time: time,
                count: member_count,
                previous_count: previous_count}
    render json: result
  end

  def worklounge
  end

  def fixed
  end

  def flex
  end
end
