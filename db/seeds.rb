User.find_or_create_by!(email: 'user@tm.com') do |user|
  user.password = '123456'
  user.password_confirmation = '123456'
end

User.find_or_create_by!(email: 'admin@tm.com') do |user|
  user.password = 'admin_tm'
  user.password_confirmation = 'admin_tm'
  user.role = 'admin'
end
