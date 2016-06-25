class TalksController < ApplicationController
  require "json"
  # require "rest-client"
  protect_from_forgery except: :callback

  # def callback
  #   p params
  #   message = params["entry"][0]["messaging"][0] #unless !params.present? || !params["entry"].present?
  #   if message.include?("message")
  #     #ユーザーの発言
  #     sender = message["sender"]["id"]
  #     text = message["message"]["text"]
  #     endpoint_uri = "https://graph.facebook.com/v2.6/me/messages?access_token=" + token
  #     request_content = {recipient: {id:sender},
  #                       message: {text: text}
  #                       }
  #     content_json = request_content.to_json
  #       RestClient.post(endpoint_uri, content_json, {
  #         'Content-Type' => 'application/json; charset=UTF-8'
  #         }){ |response, request, result, &block|
  #           p response
  #           p request
  #           p result
  #         } 
  #   else
  #       render json: "Error, wrong validation token"
  #   end
  # end

  def callback
    # request_body = JSON.parse(request.body.read) 
    if request.body.read.present?
      logger.info("--------------------------------------------")
      logger.info(request.body.read)
      
      request_body = JSON.parse(request.body.read) 
      messaging_events = request_body["entry"][0]["messaging"]

      messaging_events.each do |event|
        sender = event["sender"]["id"]
  
        if !event["message"].nil? && !event["message"]["text"].nil?
          text = event["message"]["text"]
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
