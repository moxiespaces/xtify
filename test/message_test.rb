require File.expand_path('../helper', __FILE__)

class MessageTest < Test::Unit::TestCase
  context "A new message" do
    setup do
      @message = Xtify::Message.new(
        :subject => "Fake Subject",
        :message => "Fake Message",
        :action => {
          :type => Xtify::Action::TYPES[:rich],
          :data => "fake data",
          :label => "fake label"
        },
        :rich => {
          :subject => "Fake Rich Subject",
          :message => "Fake Rich Message",
          :action => {
            :type => Xtify::Action::RICH_TYPES[:web],
            :data => "fake rich data",
            :label => "fake rich label"
          }
        },
        :payload => {:key1 => 'key2'},
        :sound => 'default.csf',
        :badge => "+1"
      )
    end

    should "properly set associations" do
      assert @message.action, "Action is missing"
      assert_equal "fake data", @message.action.data, "Action's data is wrong"

      assert @message.rich, "Rich is missing"
      assert @message.rich.action, "Rich action is missing"
      assert_equal "fake rich data", @message.rich.action.data, "Rich's action's data is wrongs"
    end

    context "that is pushed" do
      setup do
        stub_xtify_post('push', 
          "apiKey" => "FAKE_API_KEY",
          "appKey" => "FAKE_APP_KEY",
          "xids" => ["ABC123"],
          "hasTags" => ["apple", "banana"],
          "sendAll" => true,
          "inboxOnly" => false,
          "content" => {
            "subject" => "Fake Subject",
            "message" => "Fake Message",
            "action" => {
              "type" => "RICH",
              "data" => "fake data",
              "label" => "fake label"
            },
            "rich" => {
              "subject" => "Fake Rich Subject",
              "message" => "Fake Rich Message",
              "action" => {
                "type" => "WEB",
                "data" => "fake rich data",
                "label" => "fake rich label"
              }
            },
            "payload" => {"key1" => "key2"},
            "sound" => "default.csf",
            "badge" => "+1"
          }
        ).to_return(:status => 202)

        @message.push(
          :devices => "ABC123",
          :has_tags => ["apple", "banana"],
          :send_all => true,
          :inbox_only => false
        )
      end

      should "return success" do
        true
      end
    end
  end
end