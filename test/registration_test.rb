require File.expand_path('../helper', __FILE__)

class RegistrationTest < Test::Unit::TestCase
  context "Register an apple device" do
    setup do
      @xid = "ABC123"

      stub_xtify_post('users/register',
        :appKey => 'FAKE_APP_KEY',
        :installID => 'fake_user',
        :type => 'IOS',
        :deviceToken => 'fake_device_token'
      ).to_return(
        :status => 200,
        :body => "{\"xid\":\"#{@xid}\"}"
      )
    end

    should "return expected device" do
      true
    end
  end

  context "Register an google device" do
    setup do
      @xid = "ABC123"

      stub_xtify_post('users/register',
        :appKey => 'FAKE_APP_KEY',
        :installID => 'fake_user',
        :type => 'GCM',
        :registrationID => 'fake_registration_id'
      ).to_return(
        :status => 200,
        :body => "{\"xid\":\"#{@xid}\"}"
      )
    end

    should "return expected device" do
      true
    end
  end

  context "Register a device with an invalid type" do

    should "raise an InvalidRequest" do
      assert_raises Xtify::InvalidRequest do
        @device = Xtify.register_device(
          :install_id => 'fake_user', 
          :type => 'FAKE_TYPE',
          :registration_id => 'fake_registration_id')
      end
    end
  end

  context "Register a device with no install id" do

    should "raise an InvalidRequest" do
      assert_raises Xtify::InvalidRequest do
        @device = Xtify.register_device(
          :type => Xtify::Device::TYPES[:android],
          :registration_id => 'fake_registration_id')
      end
    end
  end
end