class TalksController < ApplicationController
  def new
  end
  
  def callback
    token = "EAAI9422tpG8BAFrKuTdGvZA4yKSmLCHwp6O0KI4vYEcmHqwhuKyMTwKR4C9ZCMuvLmRN8I3qsU5SmalrqPx1HFZArl2yToNA81VEWSDumPlNZBEtLTiOeuLQZClXOnw5wuqKZAGYIIL01L0WliMz3TFMGAt7l890XhU6V1zDT9qwZDZD"
    logger.info(params)
    
    message = params["entry"][0]["messaging"][0] unless !params.present? || !params["entry"].present?

    if message.include?("message")

      #ユーザーの発言
      sender = message["sender"]["id"]
      text = message["message"]["text"]

      endpoint_uri = "https://graph.facebook.com/v2.6/me/messages?access_token=" + token
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
        render json: "Error, wrong validation token"
    end
  end
end
