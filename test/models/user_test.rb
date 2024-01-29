# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test 'tasks_list should return tasks based on given parameters' do
    # Create tasks for the user
    task1 = Task.create(title: 'Task 1', description: 'Description 1', status: 'To Do', user: @user)
    task2 = Task.create(title: 'Task 2', description: 'Description 2', status: 'In Progress', user: @user)
    task3 = Task.create(title: 'Task 3', description: 'Description 3', status: 'Done', user: @user)

    # Test with no search text, all statuses, default sorting
    result_all = @user.tasks_list('All', '', nil, nil)
    assert_equal [task1, task2, task3], result_all

    # Test with search text, all statuses, custom sorting
    result_search = @user.tasks_list('All', 'Task 2', 'created_at', 'DESC')
    assert_equal [task2], result_search

    # Test with search text, specific status, default sorting
    result_status = @user.tasks_list('In Progress', 'Description', nil, nil)
    assert_equal [task2], result_status

    # Add more test cases based on your specific scenarios

    # Clean up tasks created for the test
    Task.destroy_all
  end

  test 'full_name presence' do
    @user.full_name = ''
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors[:full_name]
  end

  test 'email presence' do
    @user.email = ''
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors[:email]
  end

  test 'email uniqueness' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase # Case-insensitive uniqueness
    @user.save
    assert_not duplicate_user.valid?
    assert_equal ['has already been taken'], duplicate_user.errors[:email]
  end

  test 'full_name length' do
    @user.full_name = 'a' * 21
    assert_not @user.valid?
    assert_equal ['is too long (maximum is 20 characters)'], @user.errors[:full_name]
  end

  test 'email length' do
    @user.email = 'a' * 26
    assert_not @user.valid?
    assert_equal ['is too long (maximum is 25 characters)'], @user.errors[:email]
  end

  test 'profile_pic_url length' do
    @user.profile_pic_url = 'a' * 301
    assert_not @user.valid?
    assert_equal ['is too long (maximum is 300 characters)'], @user.errors[:profile_pic_url]
  end

  test 'password presence' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
    assert_equal ["can't be blank"], @user.errors[:password]
  end
end
