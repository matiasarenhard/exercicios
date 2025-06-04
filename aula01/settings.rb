class Settings
  def add(key, value, aliases: nil, readonly: false)
    instance_variable_set("@#{key}", value)
    define_setter(key, value, readonly)
    define_getter(key)
    if aliases
      instance_variable_set("@#{aliases}", value)
      define_setter(aliases, value, readonly)
      define_getter(aliases)
    end  
  end

  def all
    result = {}
    instance_variables.each do |var|
      key = var.to_s.delete_prefix("@").to_sym
      result[key] = instance_variable_get(var)
    end
    puts result
  end

  def method_missing(key)
    "Configuração '#{key}' não existe."
  end

  private

  def define_setter(key, value, readonly)
    define_singleton_method("#{key}=") do |value|
      return config_method_missing(key) if readonly
      instance_variable_set("@#{key}", value)
    end
  end

  def define_getter(key)
    define_singleton_method(key) do
      instance_variable_get("@#{key}")
    end
  end

  def config_method_missing(key)
    puts "Erro: configuração '#{key}' é somente leitura"
  end  
end
