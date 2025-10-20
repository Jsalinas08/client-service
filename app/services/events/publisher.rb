require 'json'

module Events
  class Publisher
    def self.publish(channel, payload)
      message = payload.to_json
      REDIS.with { |conn| conn.publish(channel, message) }
      Rails.logger.info("📤 Event published to #{channel}")
    rescue Redis::BaseConnectionError => e
      Rails.logger.error("Redis connection error publishing to #{channel}: #{e.message}")
      raise
    rescue StandardError => e
      Rails.logger.error("Error publishing event to #{channel}: #{e.message}")
      raise
    end
  end
end