FactoryBot.define do
  factory :user do
    name {'テストユーザー'}
    admin {true}
    email {'test1@example.com'}
    password {'password'}
  end

end