require 'rails_helper'

RSpec.describe MemberCount, type: :model do

  before :all do
    MemberCount.create!(kind: :total, count: 10)
    MemberCount.create!(kind: :total, count: 11)
    MemberCount.create!(kind: :total, count: 12)
  end

  it 'returns a timeline' do
    puts "=============================\n"
    puts MemberCount.json_for_total
    puts "=============================\n"
  end
end
