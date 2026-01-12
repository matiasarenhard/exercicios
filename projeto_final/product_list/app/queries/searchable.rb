module Searchable
  extend ActiveSupport::Concern

  Field = Struct.new(:name, :type, :converter, keyword_init: true)

  included do
    class_attribute :search_fields, default: []
  end

  class_methods do
    def search_text(field)
      add_field(name: field, type: :text)
    end

    def search_numeric(field, converter: :to_i)
      add_field(name: field, type: :numeric, converter: converter)
    end
    
    def add_field(**attrs)
      self.search_fields += [Field.new(**attrs)]
    end
  end

  private

  def search_conditions
    search_fields.filter_map do |field|
      build_condition(field)
    end
  end

  def build_condition(field)
    case field.type
    when :text
      { "#{field.name}_cont": search_term }

    when :numeric
      value = convert_numeric(field)
      value&.positive? ? { "#{field.name}_eq": value } : nil
    end
  end

  def convert_numeric(field)
    return unless search_term.respond_to?(field.converter)

    search_term.public_send(field.converter)
  rescue ArgumentError, TypeError
    nil
  end
end