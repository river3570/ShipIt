Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # 認証
      devise_for :users,
        path: "auth",
        path_names: {
          sign_in:  "sign_in",
          sign_out: "sign_out",
          registration: "sign_up"
        },
        controllers: {
          sessions:      "api/v1/auth/sessions",
          registrations: "api/v1/auth/registrations"
        }
    end
  end
end
