module FeedbacksHelper

  def address_info(feedback, current_user)
    if feedback.author == feedback.user && feedback.author == current_user
      'Feedback Request'
    elsif feedback.author == feedback.user
      "Feedback Request from #{feedback.user.full_name}"
    elsif feedback.user == current_user
      "#{feedback.author.full_name}"
    else
      "Feedback for #{feedback.user.full_name}"
    end
  end

  def vote_numbers(feedback_or_comment, current_user)
    path = feedback_or_comment.instance_of?(Feedback) ? vote_feedback_path(feedback_or_comment.id) : vote_comment_path(feedback_or_comment.id)
    output = "<div class='vote agree' data-action='#{path}'><div class='number'>#{feedback_or_comment.peers_in_agreement.count + 1}</div><div class='text'>agree</div></div><div class='vote dismiss' data-action='#{path}'><div class='number'>#{feedback_or_comment.peers.count + 1}</div><div class='text'>peers</div></div>"
    if current_user.agrees_with(feedback_or_comment)
      output.gsub!('agree\'', 'agree selected\'')
    elsif current_user.is_peer?(feedback_or_comment)
        output.gsub!('dismiss', 'dismiss selected')
    end
    output.html_safe
  end

  def flavor_text(feedback_or_comment)
    output = "<div class='#{feedback_or_comment.resonance_text.downcase}'>" + feedback_or_comment.resonance_text + '</div>'
    output.html_safe
  end

  def hidden_comments_count(feedback, user)
    total_comments = feedback.comments.count
    fresh_comments = feedback.fresh_comments(user).count.count
    if total_comments < 3
      0
    elsif fresh_comments > 2
      total_comments - fresh_comments
    else
      total_comments - 2
    end
  end


end