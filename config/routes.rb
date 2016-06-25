Rails.application.routes.draw do
 post 'api/fb_callback', to: 'talks#callback'
  
end
