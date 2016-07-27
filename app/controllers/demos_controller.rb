class DemosController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create_demo_user
    pass = ('0'..'z').to_a.shuffle.first(10).join
    name_json = params[:name]
    email_json = params[:email]
    @resource = User.new({:email => email_json, :password => pass, :password_confirmation => pass , :name => name_json})
    response = @resource.as_json
    response['password'] = pass
    if @resource.save
      render json: response  , status: :ok
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end
end
