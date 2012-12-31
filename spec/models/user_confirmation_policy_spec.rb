require_relative '../../app/models/user_confirmation_policy'
require 'active_support/core_ext/numeric/time'


describe UserConfirmationPolicy do

  let(:user) { stub(:user) }

  subject { UserConfirmationPolicy.new(user) }

  it "should not require a prompt if a confirmation email was not sent" do
    user.should_receive(:confirmation_sent_at).and_return(nil)
    subject.requires_confirmation_prompt?.should be_false
  end

  it "should not require a prompt if a confirmation email was sent recently" do
    user.should_receive(:confirmation_sent_at).and_return(24.hours.ago)
    subject.requires_confirmation_prompt?(48.hours).should be_false
  end

  it "should require a prompt if a confirmation was not sent recently" do
    user.should_receive(:confirmation_sent_at).and_return(96.hours.ago)
    subject.requires_confirmation_prompt?(48.hours).should be_true
  end

end
