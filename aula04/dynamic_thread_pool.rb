require_relative 'priority_queue'

class DynamicThreadPool
  def initialize(max_threads: 2)
    @max_threads = max_threads
    @threads = []
    @queue = PriorityQueue.new
    @shutdown = false
    start_threads
  end

  def schedule(priority = :medium, &block)
    @queue.add(priority, &block)
  end

  def shutdown
    @shutdown = true
    @threads.each(&:kill)
    @threads.each(&:join)
  end

  private

  def start_threads
    @max_threads.times do
      thread = Thread.new do
        while !@shutdown
          task = @queue.next_task
          task ? task.call : sleep(0.1)
        end
      end
      @threads << thread
    end
  end
end