
class OverdueService
  def call
    return success_result(0) if overdue_tasks.blank?

    updated_count = overdue_tasks.update_all(status: :overdue)
    success_result(updated_count, message: build_success_message(updated_count))
  rescue => e
    handle_error(e)
  end

  private

  def overdue_tasks
    @overdue_tasks ||= Task.overdue
  end

  def success_result(count, message: nil)
    {
      success: true,
      count: count,
      message: message
    }.compact
  end

  def handle_error(error)
    Rails.logger.error("OverdueService failed: #{error.message}")
    {
      success: false,
      error: error.message,
      count: 0
    }
  end

  def build_success_message(updated_count)
    "#{updated_count} task#{'s' if updated_count != 1} updated to overdue status"
  end
end
