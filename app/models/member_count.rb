class MemberCount < ApplicationRecord

  scope :total,   -> { where(kind: 'total') }
  scope :fixed,   -> { where(kind: 'fixed') }
  scope :flex,    -> { where(kind: 'flex') }
  scope :worklounge, -> { where(kind: 'worklounge') }

  def self.second_latest
    MemberCount.order(:created_at).offset(1).last
  end

end
