require 'rails_helper'

RSpec.describe MemberCount, type: :model do

  before :all do
    MemberCount.destroy_all # Let Database cleaner handle this.
    Timecop.freeze( DateTime.parse('1.5.2000') )
    MemberCount.create!(kind: :total, count: 10)

    Timecop.freeze( DateTime.parse('2.5.2000') )
    MemberCount.create!(kind: :total, count: 11)

    Timecop.freeze( DateTime.parse('2.5.2000') )
    MemberCount.create!(kind: :total, count: 12)
  end

  it 'returns a timeline WIP' do
    puts "=============================\n"
    puts MemberCount.json_for_total
    puts MemberCount.all.size
    puts "=============================\n"
  end
end
