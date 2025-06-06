require_relative 'html_builder'

builder = HtmlBuilder.new do
  div do
    div "Conteúdo em div"
    span "Nota em div"
  end
  span "Nota de rodapé"  
end

puts builder.result # <div><div>Conteúdo em div</div><span>Nota em div</span></div><span>Nota de rodapé</span>