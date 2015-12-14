module FeedbacksHelper

  def address_info(feedback, current_user)
    if feedback.author == current_user
      "ME to #{feedback.user.email}"
    elsif feedback.user == current_user
      "#{feedback.author.email} to ME"
    else
      "#{feedback.author.email} to #{feedback.user.email}"
    end
  end

  def vote_numbers(feedback, current_user)
    output = "<div class='number agree' data-action='#{vote_feedback_path(feedback.id)}'>#{feedback.peers_in_agreement.count + 1}</div><div class='number dismiss' data-action='#{vote_feedback_path(feedback.id)}'>#{feedback.peers.count + 1}</div>"
    if current_user.agrees_with(feedback)
      output.gsub!('agree', 'agree selected')
    elsif current_user.is_peer?(feedback)
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