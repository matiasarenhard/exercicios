Task.destroy_all if defined?(Task)

today = Date.today

tasks = [
  { title: "Buy groceries at the market", description: "Purchase milk, bread, eggs, and cheese from the local store", status: :initial, delivery_date: today + 2.days },
  { title: "Complete Ruby homework assignment", description: "Work through and finish all exercises for lesson 5", status: :in_progress, delivery_date: today + 1.day },
  { title: "Schedule a dentist appointment", description: "Call the dental clinic to book a routine check-up", status: :overdue, delivery_date: today - 1.day },
  { title: "Read a new book", description: "Read at least 20 pages from a new book", status: :completed, delivery_date: today },
  { title: "Cancel old magazine subscription", description: "Contact customer service to cancel the outdated magazine subscription", status: :cancelled, delivery_date: today + 5.days }
]

tasks.each do |task_attrs|
  Task.create!(task_attrs)
end

puts "Seeded #{Task.count} tasks."