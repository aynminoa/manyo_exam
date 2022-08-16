FactoryBot.define do
  
  factory :user do
    id { 1 }
    name { 'test_general' }
    email { 'general@example.com' }
    password { 'testpassword'}
    password_confirmation { 'testpassword'}
    admin { false }
  end

  factory :admin_user, class: User do
    id { 2 }
    name { 'test_admin' }
    email { 'admin@example.com' }
    password { 'adminpassword'}
    admin { true }
  end

end
