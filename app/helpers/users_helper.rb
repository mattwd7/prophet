module UsersHelper

  def options_with_images(users)
    output = users.map do |user|
      "<option data-img-src='#{user.avatar.url{:large}}'>#{user.user_tag}</option>"
    end
    output.join('').html_safe
  end

end