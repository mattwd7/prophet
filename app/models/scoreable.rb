module Scoreable

  RESONANCE_TEXT = ['ISOLATED', 'MIXED', 'RESONANT']

  # resonance values 0, 1, or 2
  # resonance value -1 for requests
  def calc_resonance_value
    agree_count = self.peers_in_agreement.count.to_f
    peer_count = self.peers.count.to_f
    if peer_count < 2 || agree_count < 2 || agree_count / peer_count < 0.33
      0
    elsif agree_count / peer_count < 0.7
      1
    else
      2
    end
  end

  def resonance_text
    RESONANCE_TEXT[self.resonance_value]
  end

end