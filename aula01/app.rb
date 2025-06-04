require_relative 'settings'

settings = Settings.new

# Definindo configurações dinamicamente
settings.add(:timeout, 30)
settings.add(:mode, "production")

# Acessando configurações via método
puts settings.timeout # => 30
puts settings.mode # => "production"

# Tentando acessar configuração inexistente
puts settings.retry # => "Configuração 'retry' não #existe."

# Checando se um método está disponível
puts settings.respond_to?(:timeout) # => true
puts settings.respond_to?(:retry) # => false

# Adicionando aliases 
settings.add(:timeout, 30, aliases: :espera)
puts settings.timeout # => 30
puts settings.espera  # => 30
settings.timeout = 60
puts settings.timeout # => 60

# Adicionando configuração somente leitura
settings.add(:api_key, "SECRET", readonly: true)
settings.api_key = "HACKED" # => Erro: configuração 'api_key' é somente leitura

