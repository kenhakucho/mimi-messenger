class TalksController < ApplicationController
  require "json"
  require "rest-client"
  protect_from_forgery except: :callback

  def callback
    if request.body.read.present?
      request_body = JSON.parse(request.body.read) 
      logger.info("request_body : #{request_body}")
      messaging_events = request_body["entry"][0]["messaging"]

      logger.info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
      logger.info("messaging_events : #{messaging_events.count}")
      logger.info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
      
      messaging_events.each do |event|
        sender = event["sender"]["id"]
        
        if !event["message"].nil? && !event["message"]["text"].nil?
          text = event["message"]["text"]

          logger.info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
          logger.info(p text)
          logger.info("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

          bot_response(sender, text)
        end
      end

      status 201
      body ''
    end 
  end
  
  def bot_response(sender, text)
    request_endpoint = "https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV["FACEBOOK_PAGE_TOKEN"]}"
    request_body = text_message_request_body(sender, text)
    RestClient.post request_endpoint, request_body, content_type: :json, accept: :json
  end
  
  def text_message_request_body(sender, text)
    {
      recipient: {
        id: sender
      },
      message: {
        text: text
      }
    }.to_json
  end
end
