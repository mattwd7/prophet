class AddResonanceValueToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :resonance_value, :integer
  end
end
