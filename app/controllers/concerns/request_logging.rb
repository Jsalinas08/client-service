module RequestLogging
  extend ActiveSupport::Concern

  included do
    after_action :log_request_info, only: [:create, :show, :index]
  end

  ENTITY_ID_PERMITTED = ["create", "show"].freeze
  private

  def log_request_info
    Rails.logger.info "📡 Ejecutando Hilo de publish_event: Invoices.#{action_name}"
    publish_event(payload: log_request_payload)
  end

  def publish_event(payload:)
    Thread.new { Events::Publisher.publish("invoices.#{action_name}", payload) }
  rescue => e
    Rails.logger.error("Failed to publish Invoices.created event: #{e.message}")
  end

  def log_request_payload
    json = {
      service: 'audit',
      timestamp: Time.current.utc.iso8601,
      request_id: request.request_id,
      host: request.host,
      controller: controller_name,
      path: request.fullpath,
      http_method: request.method,
      action_name: action_name,
      params: request.request_parameters,
      query_parameters: request.query_parameters,
      response_status: response&.status&.to_s,
      response_body: response&.body
    }
    json[:entity_id] = params[:id] || object_id if ENTITY_ID_PERMITTED.include?(action_name)

    json
  rescue => e
    Rails.logger.error("Failed to log_request_payload: #{e.message}")
    {}
  end

  def log_request_payload_error(code, message)
    json = log_request_payload
    json[:response_status] = code
    json[:response_body] = message

    json
  end

  def object_id
    JSON.parse(response&.body)&.dig("id")
  rescue => e
    Rails.logger.error("Failed to parse object_id: #{e.message}")
    nil
  end
end