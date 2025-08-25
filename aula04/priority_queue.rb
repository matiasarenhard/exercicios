
class PriorityQueue
  PRIORITIES = [:high, :medium, :low]

  def initialize
    @queues = PRIORITIES.map { |p| [p, Queue.new] }.to_h
    @mutex = Mutex.new
  end

  def add(priority, &block)
    priority = PRIORITIES.include?(priority.to_sym) ? priority.to_sym : :low
    @queues[priority].push(block)
  end

  def next_task
    @mutex.synchronize do
      PRIORITIES.each do |priority|
        queue = @queues[priority]
        return queue.pop unless queue.empty?
      end
      nil
    end
  end
end