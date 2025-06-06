class Vector2
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def *(value)
    case value
    when Numeric
      Vector2.new(x * value, y * value)
    when Vector2
      x * value.x + y * value.y
    else
      raise ArgumentError, "Multiplicação não suportada para #{value.class}"
    end
  end

  def coerce(value)
    return [self, value] if value.is_a?(Numeric)
    raise ArgumentError, "Coerce não suportado para #{value.class}"
  end

  def to_s
    "(#{x}, #{y})"
  end
end
