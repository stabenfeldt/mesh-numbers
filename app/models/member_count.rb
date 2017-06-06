class MemberCount < ApplicationRecord
  require 'OfficeRnDQuery'

  scope :total,   -> { where(kind: 'total') }
  scope :fixed,   -> { where(kind: 'fixed') }
  scope :flex,    -> { where(kind: 'flex') }
  scope :worklounge, -> { where(kind: 'worklounge') }

  def self.second_latest
    MemberCount.order(:created_at).offset(1).last
  end

  def self.new_or_return_latest
    member_count = MemberCount.where("created_at >= ?", Time.zone.now.beginning_of_day).first
    MemberCount.create!(kind: 'total', count: OfficeRnDQuery.total) unless member_count
    return member_count
  end

  def self.json_for_total
    time            = MemberCount.last.created_at      rescue 0
    member_count    = MemberCount.new_or_return_latest rescue 0
    previous_count  = MemberCount.second_latest.count  rescue 0

    return {
      time: time,
      count: member_count,
      previous_count: previous_count
    }

  end

end
