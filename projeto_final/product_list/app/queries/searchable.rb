module Searchable
  extend ActiveSupport::Concern

  Field = Struct.new(:name, :type, :converter, :predicate, keyword_init: true)

  DEFAULT_PREDICATES = {
    text: :cont,
    numeric: :eq
  }.freeze

  included do
    class_attribute :search_fields, default: []
  end

  class_methods do
    def search_text(field, predicate: :cont)
      add_field(name: field, type: :text, predicate: predicate)
    end

    def search_numeric(field, converter: :to_i, predicate: :eq)
      add_field(name: field, type: :numeric, converter: converter, predicate: predicate)
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
    predicate = field.predicate || DEFAULT_PREDICATES[field.type]

    case field.type
    when :text
      { "#{field.name}_#{predicate}": search_term }

    when :numeric
      value = convert_numeric(field)
      value&.positive? ? { "#{field.name}_#{predicate}": value } : nil
    end
  end

  def convert_numeric(field)
    return unless search_term.respond_to?(field.converter)

    search_term.public_send(field.converter)
  rescue ArgumentError, TypeError
    nil
  end
end