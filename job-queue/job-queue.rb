class Task
  attr_accessor :id, :duration

  def initialize(id, duration)
    @id = id
    @duration = duration
  end
end

# Worker represents a processing unit that can handle one task at a time
class Worker
  attr_reader :current_task, :time_remaining

  def initialize
    @current_task = nil
    @time_remaining = 0
  end

  def free?
    @current_task.nil?
  end

  def assign_task(task)
    raise "Worker is already busy!" unless free?

    @current_task = task
    @time_remaining = task.duration
  end

  def advance_time
    return nil if free?
    
    @time_remaining -= 1
    
    if @time_remaining == 0
      finished_task = @current_task
      @current_task = nil
      @time_remaining = 0
      return finished_task
    end
    nil
  end

  def time_left
    "#{@current_task.id}(#{@time_remaining}s left)"
  end
end

class Clock
  attr_reader :time_now
  
  def initialize
    @time_now = 0
  end

  def increment
    @time_now += 1
  end
end

class Scheduler
  def initialize(task_data, max_workers)
    @task_queue = Queue.new
    @clock = Clock.new
    
    # Create and add tasks to queue
    task_data.each do |data|
      task = Task.new(data[:id], data[:duration])
      @task_queue << task
    end
    
    @workers = Array.new(max_workers) { Worker.new }
    @completed_tasks = []
  end

  def report_status
    puts "\nTime #{@clock.time_now}:"
    @workers.each do |worker|
      if worker.free?
        puts "Worker #{worker} is free!"
      else
        puts "Worker #{worker} is doing task #{worker.current_task.id} with #{worker.time_remaining}s left"
      end
    end
    puts "Queue: #{@task_queue.size} tasks remaining"
    puts "Completed: #{@completed_tasks.map(&:id).join(', ')}"
  end

  def start
    loop do
      if @workers.all?(&:free?) && @task_queue.empty?
        puts "All tasks completed!"
        return
      end
         
      # First try to assign tasks to free workers
      @workers.each do |worker|
        if worker.free? && !@task_queue.empty?
          worker.assign_task(@task_queue.pop)
        elsif !worker.free?
          if finished_task = worker.advance_time
            @completed_tasks << finished_task
          end
        end
      end

      report_status
      puts("***************************************")
      @clock.increment
    end
  end
end

# Example usage
queue = [
  { id: "A", duration: 3 },
  { id: "B", duration: 2 },
  { id: "C", duration: 4 },
  { id: "D", duration: 1 },
  { id: "E", duration: 6 }
]
max_workers = 2

puts("The queue is: #{queue}")
puts("Max workers: 2")
scheduler = Scheduler.new(queue, max_workers)
scheduler.start
