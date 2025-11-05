require 'factory_bot_rails'
require 'faker'

puts "Seeding tasks..."

Task.delete_all

FactoryBot.create_list(:task, 10)

FactoryBot.create_list(:overdue_task, 5)

FactoryBot.create_list(:completed_task, 5)

FactoryBot.create_list(:cancelled_task, 3)

FactoryBot.create_list(:in_progress_task, 10)

puts "Done! Created:"
puts "  #{Task.where(status: 'initial').count} initial tasks"
puts "  #{Task.where(status: 'overdue').count} overdue tasks"
puts "  #{Task.where(status: 'completed').count} completed tasks"
puts "  #{Task.where(status: 'cancelled').count} cancelled tasks"
puts "  #{Task.where(status: 'in_progress').count} in progress tasks"
puts "Total: #{Task.count} tasks"