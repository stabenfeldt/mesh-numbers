class CreateMemberCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :member_counts do |t|
      t.integer :count

      t.timestamps
    end
  end
end
