Paperclip.interpolates(:user) do |attachment, style|
  "#{attachment.instance.id}"
end