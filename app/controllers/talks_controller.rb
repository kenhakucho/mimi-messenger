class TalksController < ApplicationController
  def new
  end
  
  def callback
   if params["hub.verify_token"] == "EAAI9422tpG8BAFa3KMZBgdUEXcejJKY961vbVlPJ6G0FNYYeRzyytZB2gmmxeR4X3fGf9uWSSHAlkrZCNfIrV0fSF2ambmeobIF0CrJKJJZByl22NJW7jZBzd9dXkFzGwInS2FXAqBuB1S8ZBoQCUrM0SOAioUn0LQZAAKqtu7SkwZDZD"
      render json: params["hub.challenge"]
   else
      render json: "Error, wrong validation token"
   end
   
  end
end
