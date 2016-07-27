class DemosController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create_demo_user
    name_json = params[:name]
    email_json = params[:email]
    @resource = User.new({:email => email_json, :password => "111111", :password_confirmation => "111111"  , :name => name_json})

    if @resource.save
      render json: @resource , status: :ok
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end
end
