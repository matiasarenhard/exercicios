class Settings
  def add(key, value, aliases: nil)
    define_singleton_method(key) { value }
    define_singleton_method(aliases) { value } if aliases
  end

  def method_missing(name)
    "Configuração '#{name}' não existe."
  end
end
