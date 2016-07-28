class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def autocomplete_attributes(users)
    users.map{|p| {user_tag: p.user_tag, avatar_url: p.avatar.url(:large), name: p.full_name, title: p.title}}
  end

  def require_admin
    unless current_user.is_a?(Admin)
      render nothing: true, status: :forbidden
    end
  end

  def load_and_authorize_resource(args = {})
    class_instance = args[:class].present? ? args[:class] : controller_name.camelize.singularize.constantize
    action = args[:action].present? ? args[:action] : action_name.to_sym
    id = args[:id].present? ? args[:id] : params[:id]

    if id
      resource = class_instance.find(id)
      authorize! action, resource
      instance_variable_set("@#{class_instance.name.underscore}", resource)
    else
      authorize! action, class_instance
    end
  end

  rescue_from CanCan::AccessDenied do
    if !current_user.present?
      store_location
      if params["action"] && params["action"] == "retrieve_data"
        render :js => "window.location = '/#{@app}/sign_in'"
      else
        redirect_to root_path
      end
    else
      redirect_to root_path, :notice => 'You do not have permission to access these details'
    end
  end

  def store_location
    session[:return_to_is_get] = (request.request_method_symbol == :get)
    if request.request_method_symbol != :get
      session[:return_to_params] = params
    else
      session[:return_to] = request.fullpath
    end
  end

end
