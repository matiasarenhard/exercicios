class HtmlBuilder
  attr_accessor :html

  def initialize(&block)
    @html = ""
    instance_eval(&block) if block_given?
  end

  def div(content = nil, &block)
    build_tag("div", content, &block)
  end

  def span(content = nil, &block)
    build_tag("span", content, &block)
  end

  def result
    html
  end

  private

  def build_tag(tag, content = nil, &block)
    html << "<#{tag}>"
    if block_given?
      instance_eval(&block)
    else
      html << content
    end
    html << "</#{tag}>"
  end
end
