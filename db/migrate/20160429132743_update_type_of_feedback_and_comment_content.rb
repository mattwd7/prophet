class UpdateTypeOfFeedbackAndCommentContent < ActiveRecord::Migration
  def change
    change_column :feedbacks, :content, :text
    change_column :comments, :content, :text
  end
end
