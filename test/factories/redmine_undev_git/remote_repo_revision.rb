FactoryGirl.define do
  factory :remote_repo_revision do
    repo
    sequence(:sha) { |n| Digest::SHA1.hexdigest "sha#{n}" }

    trait :author do
      author
      author_string { "#{author.name} <#{author.email}>" }
      author_date { generate :time_seq }
    end

    trait :committer do
      committer
      committer_string { "#{committer.name} <#{committer.email}>" }
      committer_date { generate :time_seq }
    end

    factory :full_repo_revision, traits: [:author, :committer] do
      message
    end
  end
end
