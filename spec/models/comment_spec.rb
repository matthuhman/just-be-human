require 'rails_helper'

describe Comment, type: :model do
  let(:comment) { build(:comment) }

  it 'testing rspec' do
    expect(comment).to belong_to(:user)
  end
end
