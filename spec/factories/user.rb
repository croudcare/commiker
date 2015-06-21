FactoryGirl.define do

  factory :auth_user, class: Commiker::V0::User do
    avatar_url 'http://avatar.url'
    email 'auth_user@example.com'
    name 'auth_user'
    slack_uid 'auth_user_uid'
    slack_handler 'auth_user_handler'
    registration_complete true
  end

  factory :omagad_user, class: Commiker::V0::User do
    avatar_url 'http://avatar.url'
    email 'omagad@example.com'
    name 'omagad'
    slack_uid 'omagad_uid'
    slack_handler 'omagad_handler'
    registration_complete true
  end

  factory :iron_man_user, class: Commiker::V0::User do
    avatar_url 'http://avatar.url'
    email 'iron_man@example.com'
    name 'iron_man'
    slack_uid 'iron_man_uid'
    slack_handler 'iron_man_handler'
    registration_complete true
  end

  factory :thor_user, class: Commiker::V0::User do
    avatar_url 'http://avatar.url'
    email 'thor@example.com'
    name 'thor'
    slack_uid 'thor_uid'
    slack_handler 'thor_handler'
    registration_complete true
  end

end
