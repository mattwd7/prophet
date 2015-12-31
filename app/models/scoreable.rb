module Scoreable

  RESONANCE_TEXT = ['ISOLATED', 'MIXED', 'RESONANT']

  # resonance values 0, 1, or 2
  def calc_resonance_value
    agree_count = self.peers_in_agreement.count
    peer_count = self.peers.count
    if agree_count < (peer_count / 2)
      0
    elsif agree_count == (peer_count / 2)
      1
    else
      2
    end
  end

  def resonance_text
    RESONANCE_TEXT[calc_resonance_value]
  end

end