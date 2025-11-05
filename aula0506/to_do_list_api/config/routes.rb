Rails.application.routes.draw do
  if Rails.env.development?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end
  namespace :api do
    namespace :v1 do
      resources :tasks
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
