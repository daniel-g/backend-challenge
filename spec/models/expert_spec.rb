require 'rails_helper'

describe Expert do
  let!(:expert) { Expert.create(name: 'John', website: 'google.com') }
  let!(:friend) { Expert.create(name: 'Doe', website: 'google.com') }

  let!(:other_friend) { Expert.create(name: 'Doe 2', website: 'google.com') }
  let(:other_friend_topic) { Topic.new(title: 'Sample topic') }

  let!(:unknown_expert) { Expert.create(name: 'Emit', website: 'google.com') }
  let(:unknown_topic) { Topic.new(title: 'Sample topic dolor') }

  before do
    expert.friends << friend
    expert.friends << other_friend
    friend.friends << unknown_expert
    friend.friends << other_friend

    friend.topics << Topic.new(title: 'Sample topic ipsum')
    other_friend.topics << other_friend_topic
    unknown_expert.topics << unknown_topic
  end

  it "searches for topics of other experts that friends of friends, but are not their friends yet" do
    expect(expert.search("Sample topic")).to eq([
      expert: unknown_expert,
      path: [friend.name, unknown_expert.name],
      topic: unknown_topic,
    ])
  end
end
