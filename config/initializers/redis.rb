require 'redis'
require 'connection_pool'

begin
  puts "🔍 ENV vars loaded at Redis initializer: #{ENV.keys.select { |k| k.include?('REDIS') || k.include?('SECRET') }}"
  redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')

  REDIS = ConnectionPool.new(size: 5, timeout: 5) do
    Redis.new(url: redis_url, timeout: 1)
  end

  # Prueba la conexión
  REDIS.with { |conn| conn.ping }
  Rails.logger.info "✅ Redis conectado exitosamente a #{redis_url}"
rescue Redis::CannotConnectError, Redis::TimeoutError, Redis::BaseError => e
  Rails.logger.warn "⚠️  Redis no disponible: #{e.message}"
  Rails.logger.warn '⚠️  La aplicación continuará sin Redis'
  REDIS = nil
end
