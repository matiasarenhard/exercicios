class Settings
  def add(key, value, aliases: nil)
    instance_variable_set("@#{key}",value)
    define_setter(key, value)
    define_getter(key)
    if aliases
      instance_variable_set("@#{aliases}",value)
      define_setter(aliases, value)
      define_getter(aliases)
    end  
  end

  def method_missing(name)
    "Configuração '#{name}' não existe."
  end

  private

  def define_setter(key, value)
    define_singleton_method("#{key}=") do |value|
      instance_variable_set("@#{key}", value)
    end
  end

  def define_getter(key)
    define_singleton_method(key) do
      instance_variable_get("@#{key}")
    end
  end
end
