require_relative '../../app/models/user_confirmation_policy'
require 'active_support/core_ext/numeric/time'


describe UserConfirmationPolicy, :type => :model do

  let(:user) { double(:user) }

  subject { UserConfirmationPolicy.new(user) }

  it "should not require a prompt if a confirmation email was not sent" do
    expect(user).to receive(:confirmation_sent_at).and_return(nil)
    expect(subject.requires_confirmation_prompt?).to be_falsey
  end

  it "should not require a prompt if a confirmation email was sent recently" do
    expect(user).to receive(:confirmation_sent_at).and_return(24.hours.ago)
    expect(subject.requires_confirmation_prompt?(48.hours)).to be_falsey
  end

  it "should require a prompt if a confirmation was not sent recently" do
    expect(user).to receive(:confirmation_sent_at).and_return(96.hours.ago)
    expect(subject.requires_confirmation_prompt?(48.hours)).to be_truthy
  end

end
