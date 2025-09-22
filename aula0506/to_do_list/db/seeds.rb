Task.destroy_all if defined?(Task)

tasks = [
  { title: "Buy groceries at the market", description: "Purchase milk, bread, eggs, and cheese from the local store", status: :initial },
  { title: "Complete Ruby homework assignment", description: "Work through and finish all exercises for lesson 5", status: :in_progress },
  { title: "Schedule a dentist appointment", description: "Call the dental clinic to book a routine check-up", status: :overdue },
  { title: "Read a new book", description: "Read at least 20 pages from a new book", status: :completed },
  { title: "Cancel old magazine subscription", description: "Contact customer service to cancel the outdated magazine subscription", status: :cancelled }
]

tasks.each do |task_attrs|
  Task.create!(task_attrs)
end

puts "Seeded #{Task.count} tasks."