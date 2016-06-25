class TalksController < ApplicationController
  protect_from_forgery except: :callback

  def callback
    message = params["entry"][0]["messaging"][0]    
    
    if message.include?("message")
      sender = message["sender"]["id"]
      text = message["message"]["text"]

      endpoint_uri = "https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV["FACEBOOK_PAGE_TOKEN"]}" 
      request_content = {recipient: {id:sender},
                         message: {text: text}
                        }
      content_json = request_content.to_json

      RestClient.post(endpoint_uri, content_json, {
        'Content-Type' => 'application/json; charset=UTF-8'
      }){ |response, request, result, &block|
        p response
        p request
        p result
      }
    else
      #botの発言
    end

    # if request.body.read.present?
    #   request_body = JSON.parse(request.body.read) 
    #   logger.info("request_body : #{request_body}")
    #   messaging_events = request_body["entry"][0]["messaging"]
    #   messaging_events.each do |event|
    #     sender = event["sender"]["id"]
    #     if !event["message"].nil? && !event["message"]["text"].nil?
    #       text = event["message"]["text"]
    #       bot_response(sender, text)
    #     end
    #   end

    #   logger.info("e"*20)
    #   status 201
    #   body ''
    # end 
  end
  
  def bot_response(sender, text)
    request_endpoint = "https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV["FACEBOOK_PAGE_TOKEN"]}"

    logger.info("1"*20)
    request_body = text_message_request_body(sender, text)
    logger.info("w"*20)
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
