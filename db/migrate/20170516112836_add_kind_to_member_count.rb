class AddKindToMemberCount < ActiveRecord::Migration[5.0]
  def change
    add_column :member_counts, :kind, :string
  end
end
