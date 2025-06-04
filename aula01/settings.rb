class Settings
  def add(key, value, aliases: nil, readonly: false)
    define_variable(key, value, readonly)
    define_variable(aliases, value, readonly) if aliases
  end

  def all
    result = {}
    instance_variables.each do |var|
      key = var.to_s.delete_prefix("@").to_sym
      result[key] = instance_variable_get(var)
    end
    puts result
  end

  private

  def define_variable(key, value, readonly)
    instance_variable_set("@#{key}", value)
    define_setter(key, value, readonly)
    define_getter(key)
  end  

  def define_setter(key, value, readonly)
    define_singleton_method("#{key}=") do |value|
      return readonly_setting_error(key) if readonly
      instance_variable_set("@#{key}", value)
    end
  end

  def define_getter(key)
    define_singleton_method(key) do
      instance_variable_get("@#{key}")
    end
  end

  def readonly_setting_error(key)
    puts "Erro: configuração '#{key}' é somente leitura"
  end  

  def method_missing(key)
    "Configuração '#{key}' não existe."
  end
end
