require "test_helper"

class Telegram::ClientTest < ActiveSupport::TestCase
  test "sends the message to the configured chat" do
    http = RecordingHttp.new
    client = Telegram::Client.new(token: "secret-token", chat_id: "99", http: http)

    client.deliver("Nueva solicitud")

    assert_equal "api.telegram.org", http.hostname
    assert_equal "/botsecret-token/sendMessage", http.path
    assert_equal({ "chat_id" => "99", "text" => "Nueva solicitud" }, JSON.parse(http.body))
  end

  test "stays quiet without credentials" do
    http = RecordingHttp.new(forbid_connection: true)
    client = Telegram::Client.new(token: "", chat_id: "", http: http)

    assert_nil client.deliver("Nueva solicitud")
  end

  test "raises when Telegram rejects the message" do
    http = RecordingHttp.new(code: "403")
    client = Telegram::Client.new(token: "secret-token", chat_id: "99", http: http)

    error = assert_raises(Telegram::DeliveryError) { client.deliver("Nueva solicitud") }

    assert_equal "Telegram rechazó el aviso (403)", error.message
  end

  class RecordingHttp
    attr_reader :hostname, :path, :body

    def initialize(code: "200", forbid_connection: false)
      @code = code
      @forbid_connection = forbid_connection
    end

    def start(hostname, _port, use_ssl:, open_timeout:, read_timeout:)
      raise "should not connect" if @forbid_connection

      @hostname = hostname
      @use_ssl = use_ssl
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      yield self
    end

    def request(request)
      @path = request.path
      @body = request.body
      Response.new(@code)
    end

    class Response
      attr_reader :code

      def initialize(code)
        @code = code
      end
    end
  end
end
