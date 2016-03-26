class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def autocomplete_attributes(users)
    users.map{|p| {user_tag: p.user_tag, avatar_url: p.avatar.url(:large), name: p.full_name, title: p.title}}
  end

end
