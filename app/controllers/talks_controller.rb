class TalksController < ApplicationController
  def new
  end
  
  def callback
   if params["hub.verify_token"] == "56126624"
      render json: params["hub.challenge"]
   else
      render json: "Error, wrong validation token"
   end
  end
end
