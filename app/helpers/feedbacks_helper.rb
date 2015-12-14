module FeedbacksHelper

  def address_info(feedback, current_user)
    if feedback.author == current_user
      "ME to #{feedback.user.user_tag}"
    elsif feedback.user == current_user
      "#{feedback.author.user_tag} to ME"
    else
      "#{feedback.author.user_tag} to #{feedback.user.user_tag}"
    end
  end

  def vote_numbers(feedback_or_comment, current_user)
    path = feedback_or_comment.instance_of?(Feedback) ? vote_feedback_path(feedback_or_comment.id) : vote_comment_path(feedback_or_comment.id)
    output = "<div class='vote agree' data-action='#{path}'>#{feedback_or_comment.peers_in_agreement.count + 1}</div><div class='vote dismiss' data-action='#{path}'>#{feedback_or_comment.peers.count + 1}</div>"
    if current_user.agrees_with(feedback_or_comment)
      output.gsub!('agree', 'agree selected')
    elsif current_user.is_peer?(feedback_or_comment)
        output.gsub!('dismiss', 'dismiss selected')
    end
    output.html_safe
  end

  def flavor_text(feedback_or_comment)
    agree_count = feedback_or_comment.peers_in_agreement.count
    peer_count = feedback_or_comment.peers.count
    if agree_count > (peer_count / 2)
      'MEANINGFUL'
    elsif agree_count == (peer_count / 2)
      'MIXED'
    else
      'NEGLIGIBLE'
    end
  end


end