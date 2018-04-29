class ApplicationController < ActionController::API
  before_action :transform_params

  def transform_params
    params.transform_keys! { |key| key.tr('-', '_') }
  end

  unless Rails.env.development?
    rescue_from *RESCUABLE_EXCEPTIONS do |exception|
      status = case exception.class.to_s
               when "Elasticsearch::Transport::Transport::Errors::NotFound","AbstractController::ActionNotFound",  "ActionController::RoutingError" then 404
               when "ActiveModel::ForbiddenAttributesError", "ActionController::ParameterMissing", "ActionController::UnpermittedParameters", "NoMethodError" then 422
               else 400
               end

      if status == 404
        message = "The resource you are looking for doesn't exist."
      elsif status == 401
        message = "You are not authorized to access this page."
      else
        message = exception.message
      end

      render json: { errors: [{ status: status.to_s, title: message }] }.to_json, status: status
    end
  end
end
