FactoryBot.define do
  factory :label do
    name { 'test_label_1' }
  end

  factory :second_label, class: Label do
    name { "test_label_2" }
  end

end
