module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              message: "アカウントを作成しました",
              user: {
                id:       resource.id,
                email:    resource.email,
                username: resource.username
              }
            }, status: :created
          else
            render json: {
              message: "アカウント作成に失敗しました",
              errors: resource.errors.full_messages
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
