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
    if feedback.user == current_user
      "<div class='agree'>#{feedback.peers_in_agreement.count + 1}</div><div class='dismiss'>#{feedback.peers.count + 1}</div>".html_safe
    else
      if current_user.agrees_with(feedback)
        "<div class='agree selected'>#{feedback.peers_in_agreement.count + 1}</div><div class='dismiss'>#{feedback.peers.count + 1}</div>".html_safe
      else
        if current_user.is_peer?(feedback)
          "<div class='agree'>#{feedback.peers_in_agreement.count + 1}</div><div class='dismiss selected'>#{feedback.peers.count + 1}</div>".html_safe
        else
          "<div class='agree'>#{feedback.peers_in_agreement.count + 1}</div><div class='dismiss'>#{feedback.peers.count + 1}</div>".html_safe
        end
      end
    end
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