class MessagesController < ApplicationController

  def index
	  @our_names = { 1 => "Saeed", 2 => "Amir", 3 => "Sadegh", 4 => "Hamed", 5 => "Pouria" }
  	@messages = Messages.all
  end

  def create
    @message = Messages.new params[:user_params]
    @message.save
    # render json: @message
    redirect_to root_path
  end

  def reply
    @reply = Reply.new params[:replier_params]
    @reply.save
    redirect_to root_path
  end
end
