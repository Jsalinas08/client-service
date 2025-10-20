# Load the Rails application.
require_relative 'application'
require 'dotenv'
Dotenv.load
puts "✅ Dotenv cargado, variables disponibles: #{ENV.keys.select { |k| k.match?(/REDIS|SECRET|DB|RAILS/) }}"


# Initialize the Rails application.
Rails.application.initialize!
