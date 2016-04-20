namespace :tasks do
  desc 'creates fake tasks'

  task :create_fakes, [:user_count, :task_count] => :environment do |_t, args|
    raise ArgumentError, 'you should pass users count' unless args[:user_count]
    raise ArgumentError, 'you should pass tasks count' unless args[:task_count]

    user_count = args[:user_count].to_i
    task_count = args[:task_count].to_i

    users = []
    user_count.times do
      users << FactoryGirl.create(:user)
    end

    users.each do |user|
      task_count.times do
        FactoryGirl.create(:task, user: user)
      end
    end

    p "#{user_count} users and #{task_count} task for each user were created!"
  end
end
