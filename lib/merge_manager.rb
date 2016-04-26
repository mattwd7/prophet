class MergeManager

  def initialize(feedback_1, feedback_target)
    @feedback_1 = feedback_1
    @feedback_target = feedback_target
  end

  def merge
    merged_feedback = @feedback_target.dup
    FeedbackLink.where(feedback: [@feedback_1, @feedback_target]).each do |link|
      new_link = link.dup
      new_link.feedback = merged_feedback
      new_link.save
    end
    # TODO: start comments with the content of the other feedback (and some indicator)
    Comment.where(feedback: [@feedback_1, @feedback_target]).each do |comment|
      new_comment = comment.dup
      new_comment.feedback = merged_feedback
      new_comment.save
    end
    ShareLog.where(feedback: [@feedback_1, @feedback_target]).each do |log|
      new_log = log.dup
      new_log.feedback = merged_feedback
      new_log.save
    end

    if merged_feedback.save
      [@feedback_1, @feedback_target].each{|f| f.update_attributes(merged?: true)}
      merged_feedback.logs.create(type: 'MergeLog', user: merged_feedback.user)
      merged_feedback
    end
  end

end