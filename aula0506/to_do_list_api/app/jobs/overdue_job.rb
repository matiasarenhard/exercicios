class OverdueJob < ApplicationJob
  queue_as :default

  def perform
    OverdueService.new.call
  end
end