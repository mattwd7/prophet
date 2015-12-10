module FeedbacksHelper

  def address_info(feedback, current_user)
    if feedback.author == current_user
      "ME to #{feedback.user.email}"
    elsif feedback.user == current_user
      "#{feedback.user.email} to ME"
    else
      "#{feedback.author.email} to #{feedback.user.email}"
    end
  end

  def flavor_text(feedback)
    agree_count = feedback.peers_in_agreement.count
    peer_count = feedback.peers.count
    if agree_count > (peer_count / 2)
      'MEANINGFUL'
    elsif agree_count == (peer_count / 2)
      'MIXED'
    else
      'NEGLIGIBLE'
    end
  end


end