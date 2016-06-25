class TalksController < ApplicationController
  def new
  end
  
  def callback
   if params["hub.verify_token"] == "EAAI9422tpG8BAJge4Hr6oTxrM6M0Ixzjo5WeUNG1gvVWhNXRdCY6mYjHLA8F0CAMYz8LZAZBJBYU6vmz39192ZCXJcWkkU8iXZAPnqYt3vXXl13XyF3HYr1H9frLwRGzbWuv1IvQTGmx4HAZCIgpgynIu2AFJXrlnd7MPBo78OQZDZD"
      render json: params["hub.challenge"]
   else
      render json: "Error, wrong validation token"
   end
   
  end
end
