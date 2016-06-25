Rails.application.routes.draw do
  match "api/fb_callback" => 'talks#callback', :via => [:get,:post]
end
