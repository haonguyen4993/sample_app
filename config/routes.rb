Rails.application.routes.draw do
  namespace :static_pages do
    get "home"
    get "help"
    get "about"
    get "contact"
  end

  root "static_pages#home"
end
