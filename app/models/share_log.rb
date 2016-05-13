class ShareLog < Log

  attr_accessor :names

  before_save :format_content

  def format_content
    self.content ||= "#{self.user.full_name} added #{self.names.to_sentence}"
  end

end