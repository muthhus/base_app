class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  
  def create
    build_resource
    if resource.save
      sign_up(resource_name, resource)
      render json: resource, status: 201
      return
    else
      render json: { :errors => @user.errors.full_messages[0] }, status: 422
      return
    end    
  end
  
  def update
    resource = resource_class.find(params[:id])
    return invalid_credentials unless (resource[:authentication_token] == params[:auth_token]) 

    if resource.update_with_password(resource_params)
      render json: resource, status: 201
    else
      clean_up_passwords resource
      render json: { :errors => resource.errors.full_messages[0] }, status: 422
    end
  end
  
  protected
  def invalid_credentials
    warden.custom_failure!
    render json: {}, status: 401
  end
  
end