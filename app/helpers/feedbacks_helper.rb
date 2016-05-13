module FeedbacksHelper

  def address_info(feedback, current_user)
    if feedback.author == feedback.user
      "#{feedback.user.full_name} Self-Observation"
    elsif feedback.author == current_user
      "ME to #{feedback.user.full_name}"
    elsif feedback.user == current_user
      "Feedback from #{feedback.author.full_name}"
    else
      "#{feedback.author.full_name} to #{feedback.user.full_name}"
    end
  end

  def vote_numbers(feedback, current_user)
    path = vote_feedback_path(feedback.id)
    output = "<div class='vote agree' data-action='#{path}'><div class='number-container'><div class='number'>#{feedback.peers_in_agreement.count}</div></div><div class='text'>agree</div></div><div class='vote peers' data-action='#{path}'><div class='number-container'><div class='number'>#{feedback.peers.count}</div></div><div class='text'>peers</div></div>"
    if current_user.agrees_with(feedback)
      output.gsub!('agree\'', 'agree selected\'')
    end
    output.html_safe
  end

  def flavor_text(feedback)
    output = "<div class='#{feedback.resonance_text.downcase}'>" + feedback.resonance_text + '</div>'
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

  def hidden_comment_content(feedback, user)
    show = 2; shown = 0; output = []
    comments_and_logs = feedback.comment_history.reverse
    comments_and_logs.each do |obj|
      if shown < show || (obj.is_a?(Comment) && obj.fresh?(user))
        output << { object: obj, hidden: false }
        shown += 1 if obj.is_a?(Comment)
      elsif shown == show && obj.is_a?(Log)
        output << { object: obj, hidden: false }
        shown += 1
      else
        output << { object: obj, hidden: true }
      end
    end
    output.reverse
  end

end