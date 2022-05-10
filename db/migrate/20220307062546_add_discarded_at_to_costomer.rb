class AddDiscardedAtToCostomer < ActiveRecord::Migration[6.1]
  def change
    add_column :costomers, :discarded_at, :datetime
    add_index :costomers, :discarded_at
  end
end
