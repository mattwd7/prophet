module Scoreable

  RESONANCE_TEXT = ['ISOLATED', 'MIXED', 'RESONANT']

  # resonance values 0, 1, or 2
  def resonance_value
    agree_count = self.peers_in_agreement.count
    peer_count = self.peers.count
    if agree_count > (peer_count / 2)
      2
    elsif agree_count == (peer_count / 2)
      1
    else
      0
    end
  end

  def resonance_text
    RESONANCE_TEXT[resonance_value]
  end

end