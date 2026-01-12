class ProductQuery
  include Searchable

  attr_reader :search_term, :page, :per_page

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  search_text :name
  search_text :description
  search_numeric :value, converter: :to_f
  search_numeric :quantity

  def initialize(search_term: nil, page: DEFAULT_PAGE, per_page: DEFAULT_PER_PAGE)
    @search_term = search_term.to_s.strip
    @page = (page.to_i.positive? ? page.to_i : DEFAULT_PAGE)
    @per_page = (per_page.present? && per_page&.to_i&.positive? ? per_page.to_i : DEFAULT_PER_PAGE)
  end

  def run
    scope = Product
    scope = scope.ransack(ransack_params).result if search_term.present?
    scope.page(page).per(per_page)
  end

  private

  def ransack_params
    {
      g: search_conditions,
      m: 'or'
    }
  end
end