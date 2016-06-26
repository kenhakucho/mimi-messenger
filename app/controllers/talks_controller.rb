class TalksController < ApplicationController
  require "json"
  require "rest-client"
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
      
      logger.info('new message' + ("---"*10))
      logger.info("sender : #{sender}")
      logger.info("text : #{text}")
          
#      result = bot_response(sender, text)
#      RestClient.post(endpoint_uri, result, {
      RestClient.post(endpoint_uri, content_json, {
        'Content-Type' => 'application/json; charset=UTF-8'
      }){ |response, request, result, &block|
        p response
        p request
        p result
      }
      
      after_content = {recipient: {id:sender},
                         message: {text: "おれも"}
                        }.to_json      
      RestClient.post(endpoint_uri, after_content, {
        'Content-Type' => 'application/json; charset=UTF-8'
      }){ |response, request, result, &block|
        p response
        p request
        p result
      }
    else
      #botの発言
    end
  end
  
  def bot_response(sender, text)
    clientid = "VBVBSDOsTPSDxQpsJ6Z95MzSSrKwBp9jSgVn7Ba0G1ve"
    clientsecret="(~ZWr6mKS7<M2KX+&OmE"
    apikey="32566a494a756556334362627046676479442e6d636556352f6a71756a4c774d5a706c6f4e756b64334741"
    request_endpoint = "https://api.apigw.smt.docomo.ne.jp/scenarioDialogue/v1/registration?APIKEY=#{apikey}"

    request_body = {'botId' => 'APIBot'}
    
    appid = RestClient.post request_endpoint, request_body, content_type: :json, accept: :json 

    res = Net::HTTP.post_form(endpoint, request_body)
#    Net::HTTP.post_form(URI.parse(request_endpoint), request_body)

    # request_body = {
　　  # 'appId' => appid,
　　  # 'botId' => "APIBot",
　　  # 'voiceText' => text.presence || "init",
　　  # 'initTalkingFlag' => "true",
　　  # 'initTopicId' => "APITOPIC"
#      'appRecvTime' => "2016-6-25 19:52:31",
#      'appSendTime' => "2016-6-25 19:52:31" 
　　# }

    appid = RestClient.post request_endpoint, request_body, content_type: :json, accept: :json

#    request_endpoint = URI.parse("https://api.apigw.smt.docomo.ne.jp/scenarioDialogue/v1/dialogue?APIKEY=#{apikey}")"
　　
      # [:systemText][:expression]
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
