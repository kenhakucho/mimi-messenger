Rails.application.routes.draw do
 get 'api/fb_callback', to: 'talks#call_back'
  
end
