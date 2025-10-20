class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  include RequestLogging

  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotSaved, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from NoMethodError, with: :render_method_error

  private

  def unprocessable_entity(exception)
    publish_event(
      payload: log_request_payload_error('422', exception.record.errors.full_messages)
    )
    render json: { errors: exception.record.errors }, status: __method__
  end

  def render_method_error(exception)
    render json: {
      error: I18n.t('errors.internal_server_error'),
      message: Rails.env.development? ? exception.message : I18n.t('errors.wrong')
    }, status: :internal_server_error
  end

  def not_found
    render json: { error: I18n.t('errors.not_found') }, status: :not_found
  end
end
