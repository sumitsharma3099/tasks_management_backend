# test/models/task_test.rb
require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:one) # Assuming you have a fixture with a user named 'one'
  end

  test 'should be valid with valid attributes' do
    task = Task.new(
      title: 'Valid Title',
      description: 'Valid Description',
      status: 'To Do',
      user: @user
    )
    assert task.valid?
  end

  test 'should require title' do
    task = Task.new(description: 'Some Description', user: @user)
    assert_not task.valid?
    assert_equal ["can't be blank"], task.errors[:title]
  end

  test 'should require description' do
    task = Task.new(title: 'Some Title', user: @user)
    assert_not task.valid?
    assert_equal ["can't be blank"], task.errors[:description]
  end

  test 'title should not exceed 500 characters' do
    task = Task.new(title: 'a' * 501, description: 'Valid Description', user: @user)
    assert_not task.valid?
    assert_equal ['is too long (maximum is 500 characters)'], task.errors[:title]
  end

  test 'description should not exceed 200 characters' do
    task = Task.new(title: 'Valid Title', description: 'a' * 201, user: @user)
    assert_not task.valid?
    assert_equal ['is too long (maximum is 200 characters)'], task.errors[:description]
  end

  test 'status should be a valid enum value' do
    task = Task.new(title: 'Valid Title', description: 'Valid Description', status: "Invalid", user: @user)
    assert_not task.valid?
    assert_equal ['is not a valid status'], task.errors[:status]
  end

  test 'should belong to a user' do
    task = Task.new(title: 'Valid Title', description: 'Valid Description', user: @user)
    assert task.valid?
  end

  test 'validate_todo_limit should prevent new "To Do" task if limit reached' do
    # Create a task with "To Do" status
    Task.create(title: 'Existing Task', description: 'Existing Description', status: 'To Do', user: @user)

    # Attempt to create a new "To Do" task
    task = Task.new(title: 'New Task', description: 'New Description', status: 'To Do', user: @user)

    assert_not task.valid?
    assert_equal ['Cannot create new "To Do" task. Limit reached.'], task.errors[:base]
  end

  test 'validate_todo_limit should allow new "To Do" task if limit not reached' do
    # Create tasks with various statuses
    Task.create(title: 'Existing Task', description: 'Existing Description', status: 'In Progress', user: @user)
    Task.create(title: 'Existing Task', description: 'Existing Description', status: 'Done', user: @user)

    # Attempt to create a new "To Do" task
    task = Task.new(title: 'New Task', description: 'New Description', status: 'To Do', user: @user)

    assert task.valid?
  end
end