require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should "respond to is_gravtastic" do
    user = Factory(:user, :email => 'john@doe.com')
    assert_respond_to user, :gravatar_url
  end

  context "a user" do
    setup do
      @user = Factory(:user, :twitter => "Croaky")
    end

    should_have_many :tweets
    should_have_one :feed
    should_allow_mass_assignment_of :twitter
    should_allow_mass_assignment_of :feed_attributes

    should_allow_values_for :twitter, 'zomg'
    should_allow_values_for :twitter, '@aieeeee' #before_validation cleans this up
    should_not_allow_values_for :twitter, 'http://twitter.com/wtf'
    should_not_allow_values_for :twitter, 'foo@fail'


    should "display twitter name as string representation" do
      assert_equal "Croaky", @user.to_s
    end

    should 'display twitter url as main_url' do
      assert_equal 'http://twitter.com/croaky', @user.main_url
    end

  end

  context "creating a user with a twitter" do
    context "when the twitter name is has a leading @ sign" do
      setup do 
        @user = Factory(:user, :twitter => '@foo')
      end

      should 'save properly and remove the @ sign upon validation' do
        @user.save!
        assert_equal 'foo', @user.twitter
      end

    end

  end

  context 'calling main_url' do

    context 'when the user does not have a twitter' do
      setup do
        @user = Factory(:user, :twitter => nil)
      end

      should 'return nil' do
        assert_equal nil, @user.main_url
      end
    end

    context 'when the user has a twitter' do
      setup do
        @user = Factory(:user, :twitter => 'foo')
      end

      should 'return the twitter url' do
        assert_equal 'http://twitter.com/foo', @user.main_url
      end
    end

  end

  context 'calling has_link?' do

    context 'when the user does not have a twitter' do
      setup do
        @user = Factory(:user, :twitter => nil)
      end

      should 'return false' do
        assert_equal false, @user.has_link?
      end
    end

    context 'when the user has a twitter' do
      setup do
        @user = Factory(:user, :twitter => 'foo')
      end

      should 'return the twitter url' do
        assert_equal true, @user.has_link?
      end
    end

  end

end
