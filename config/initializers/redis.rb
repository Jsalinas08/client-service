require 'redis'
require 'connection_pool'

begin
  REDIS = ConnectionPool.new(size: 5, timeout: 5) do
    Redis.new(
      host: ENV.fetch('REDIS_HOST', 'localhost'),
      port: ENV.fetch('REDIS_PORT', 6379).to_i,
      db: ENV.fetch('REDIS_DB', 0).to_i,
      timeout: 1
    )
  end

  # Prueba la conexión
  REDIS.with { |conn| conn.ping }
  Rails.logger.info "✅ Redis conectado exitosamente"
rescue Redis::CannotConnectError, Redis::TimeoutError, Redis::BaseError => e
  Rails.logger.warn "⚠️  Redis no disponible: #{e.message}"
  Rails.logger.warn "⚠️  La aplicación continuará sin Redis"
  REDIS = nil
end