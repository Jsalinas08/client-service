module RequestLogging
  extend ActiveSupport::Concern

  included do
    after_action :log_request_info, only: [:create, :update, :show, :index]
  end

  private

  def log_request_info
    Rails.logger.info "📡 Ejecutando Hilo de publish_event: clients.#{action_name}"
    Thread.new { publish_event }
  end

  def publish_event
    Events::Publisher.publish("clients.#{action_name}", log_request_payload)
  rescue => e
    Rails.logger.error("Failed to publish clients.created event: #{e.message}")
  end

  def log_request_payload
    {
      service: 'client',
      timestamp: Time.current.utc.iso8601,
      request_id: request.request_id,
      host: request.host,
      controller: controller_name,
      path: request.fullpath,
      http_method: request.method,
      action_name: action_name,
      params: request.request_parameters,
      entity_id: params[:id] || object_id,
      query_parameters: request.query_parameters,
      response_status: response&.status&.to_s,
      response_body: response&.body
    }
  end

  def object_id
    JSON.parse(response&.body)&.dig("id")
  rescue => e
    Rails.logger.error("Failed to parse object_id: #{e.message}")
    nil
  end
end