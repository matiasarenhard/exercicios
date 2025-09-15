require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @task = Task.new(
      title: "My Task",
      description: "This is a test task",
      status: "pending"
    )
  end

  test "valid task" do
    assert @task.valid?
  end

  test "invalid without title" do
    @task.title = nil
    assert_not @task.valid?
    assert_includes @task.errors[:title], "can't be blank"
  end

  test "invalid without description" do
    @task.description = nil
    assert_not @task.valid?
    assert_includes @task.errors[:description], "can't be blank"
  end

  test "invalid without status" do
    @task.status = nil
    assert_not @task.valid?
    assert_includes @task.errors[:status], "can't be blank"
  end
end