# Exercício: ThreadPool dinâmica com fila de prioridade
# Contexto: Você está desenvolvendo um sistema de processamento de tarefas em background que deve lidar com múltiplas prioridades. Para isso, deseja implementar sua própria
# ThreadPool dinâmica, capaz de:
# -​ Executar tarefas concorrentes com múltiplas Threads.
# - Usar filas de prioridade (:high, :medium, :low) para gerenciar a ordem de execução
# -​ Permitir o aumento ou redução do número de Threads ativamente consumindo tarefas
# Objetivo:
# Implemente as seguintes classes:
# 1. PriorityQueue
#  Uma classe thread-safe que:
#  - Mantém várias filas (Queue) associadas a diferentes prioridades​
#  - Permite adicionar tarefas com prioridade específica​
#  - Retorna a próxima tarefa disponível com a mais alta prioridade disponível​
# 2. DynamicThreadPool
# Uma classe com:
#  - Um número inicial de Threads (ex: 2).​
#  - Capacidade de crescer até um número máximo de Threads (ex: até 10) dinamicamente​
#  - Acesso a métodos como schedule(priority = :medium,  &block) para adicionar tarefas.​
#  - Remoção de threads mortas dinamicamente

# Exemplo de uso:
# pool = DynamicThreadPool.new(max_threads: 3)
# 10.times do |i|
#  pool.schedule(:default) { sleep 1; puts "Tarefa
#  padrão #{i} concluída" }
# end
#
# 5.times do |i|
#  pool.schedule(:high) { sleep 0.5; puts "Tarefa
#  prioritária #{i} concluída" }
# end
# pool.shutdown​​ # => termina a execução de todas as Threads

# require_relative "priority_queue"
require_relative "dynamic_thread_pool"

# priority_queue = PriorityQueue.new
# 
# priority_queue.add(:low)  { puts 'Tarefa com prioridade baixa' }
# priority_queue.add(:medium) { puts 'Tarefa com prioridade default' }
# priority_queue.add(:high) { puts 'Tarefa com prioridade alta' }
# priority_queue.next_task # Tarefa com prioridade alta
# priority_queue.next_task # Tarefa com prioridade default
# priority_queue.next_task # Tarefa com prioridade baixa


pool = DynamicThreadPool.new(max_threads: 3)

10.times do |i|
  pool.schedule(:medium) { sleep 1; puts "Tarefa padrão #{i} concluída" }
end

5.times do |i|
  pool.schedule(:high) { sleep 0.5; puts "Tarefa prioritária #{i} concluída" }
end

sleep 5

pool.shutdown # termina a execução de todas as Threads