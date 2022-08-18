FactoryBot.define do

  factory :task do
    title { 'test_title' }
    content { 'test_content' }
    deadline { 'test_deadline'}
    status { '未着手'}
    priority { '低'}
  end

  factory :second_task, class: Task do
    title { 'test_title2' }
    content { 'test_content2' }
    deadline { 'test_deadline2'}
    status { '着手中'}
    priority { '中'}
  end

end
