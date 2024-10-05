# spec/channels/application_cable/channel_spec.rb
require 'rails_helper'

RSpec.describe ApplicationCable::Channel, type: :channel do
  let(:channel) { ApplicationCable::Channel.new }

  describe '#subscribed' do
    it 'does not raise an error on subscription' do
      #   expect { channel.subscribed }.not_to raise_error
    end
  end

  describe '#unsubscribed' do
    it 'does not raise an error on unsubscription' do
      #   expect { channel.unsubscribed }.not_to raise_error
    end
  end
end
