class MergeLog < Log

  before_save :format_content

  def format_content
    self.content = "#{self.user.full_name} merged another feedback into this one."
  end

end