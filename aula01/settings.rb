class Settings
  def add(key, value)
    define_singleton_method(key) { value }
  end

  def method_missing(name)
    "Configuração '#{name}' não existe."
  end
end
