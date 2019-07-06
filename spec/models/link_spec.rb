require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable).optional }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it 'valid with a valid url' do
    expect(Link.create(name: 'name', url: 'http://google.com')).to be_valid
  end

  it 'invalid with an invalid url' do
    expect(Link.create(name: 'name', url: 'url')).not_to be_valid
  end
end
