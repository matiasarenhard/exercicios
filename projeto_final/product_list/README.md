### Lista de produtos
Projeto simples com o objetivo de aplicar os conhecimentos adquiridos durante as aulas. 

<b>Projeto</b>:
```
  Ruby: 3.4.4
  Rails: 8.0.4
  PostgreSQL 16.8
```

<b>Comandos para o build</b>: <br>
```
  bin/bundle install
  bin/rails db:create db:migrate db:seed
  bin/rails s
```

<b>Requisitos</b>: <br>
1 - [DSL (mini linguagem específica)](https://github.com/matiasarenhard/exercicios/blob/main/projeto_final/product_list/app/queries/product_query.rb#L9) <br>
2 - [Enumerable](https://github.com/matiasarenhard/exercicios/blob/main/projeto_final/product_list/app/services/products/create_products_csv.rb#L13) <br>
3 - [Concorrência e Paralelismo](https://github.com/matiasarenhard/exercicios/blob/main/projeto_final/product_list/app/jobs/increase_product_prices_job.rb#L8) <br>

<b>Bônus</b>: <br>
4 - [Testes](https://github.com/matiasarenhard/exercicios/tree/main/projeto_final/product_list/spec) <br>
5 - [Soft Delete](https://github.com/matiasarenhard/exercicios/blob/main/projeto_final/product_list/Gemfile#L48) <br>
6 - Swagger <br>

<b>Testes</b>: <br>
```
bundle exec rspec
```
<img width="1680" height="144" alt="image" src="https://github.com/user-attachments/assets/a55e5e63-3fbb-448e-8e51-855491bc3477" />
<br>
<br>
<b>Documentação</b>: <br>
http://localhost:3000/api-docs/index.html
<img width="3366" height="1357" alt="image" src="https://github.com/user-attachments/assets/8a2282de-109f-4256-8cfe-5c6288df9627" />
