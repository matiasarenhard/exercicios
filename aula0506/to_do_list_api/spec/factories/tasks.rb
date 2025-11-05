FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 2) }
    description { Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 1) }
    status { "initial" }
    delivery_date { Faker::Date.between(from: 1.week.from_now, to: 1.month.from_now) }
  end

  factory :completed_task, parent: :task do
    status { "completed" }
  end

  factory :cancelled_task, parent: :task do
    status { "cancelled" }
    deleted_at { Date.today }
  end

  factory :overdue_task, parent: :task do
    status { "overdue" }
    delivery_date { 1.week.ago }
  end

  factory :in_progress_task, parent: :task do
    status { "in_progress" }
    delivery_date { Faker::Date.between(from: 1.day.from_now, to: 2.weeks.from_now) }
  end
end
