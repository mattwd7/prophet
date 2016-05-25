Paperclip.interpolates(:user) do |attachment, style|
  "user_#{attachment.instance.id.to_s}"
end