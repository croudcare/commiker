FactoryGirl.define do

  factory :sprint_one, class: Commiker::V0::Sprint do
    obs 'this is an observation'
    started_at Time.now
    ended_at Time.now + 7.days

    after(:create) do |sprint|
      sprint.users.create attributes_for(:omagad_user)
      sprint.users.create attributes_for(:iron_man_user)
      sprint.users.create attributes_for(:thor_user)
    end
  end

  factory :sprint_two, class: Commiker::V0::Sprint do
    obs 'this is an observation'
    started_at Time.now + 7.days
    ended_at Time.now + 14.days

    after(:create) do |sprint|
      sprint.users.create attributes_for(:iron_man_user)
      sprint.users.create attributes_for(:thor_user)
    end
  end

  factory :sprint_three, class: Commiker::V0::Sprint do
    obs 'this is an observation'
    started_at Time.now + 14.days
    ended_at Time.now + 21.days

    after(:create) do |sprint|
      sprint.users.create attributes_for(:omagad_user)
      sprint.users.create attributes_for(:thor_user)
    end
  end
end
