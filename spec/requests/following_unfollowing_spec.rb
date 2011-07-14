require 'spec_helper'

describe "Following/Unfollowing Users" do
  
  it "should successfully follow and unfollow a user" do
    user = Factory(:user)
    other_user = Factory(:user, :email => Factory.next(:email))
    integration_sign_in user
    visit user_path(other_user)
    click_button
    user.should be_following(other_user)
    click_button
    user.should_not be_following(other_user)
  end
end
