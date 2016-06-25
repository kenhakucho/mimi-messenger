class TalksController < ApplicationController
  def new
  end
  
  def callback
   puts "**********************************"
   puts params["hub.verify_token"]
   puts params["hub.challenge"]
   
  
   if params["hub.verify_token"] == "hogehoge"
      render json: params["hub.challenge"]
   else
      render json: "Error, wrong validation token"
   end
   
  end
end
