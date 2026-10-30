require "net/http"

module Telegram
  class Client
    def initialize(token: ENV["TELEGRAM_BOT_TOKEN"], chat_id: ENV["TELEGRAM_CHAT_ID"], http: ::Net::HTTP)
      @token = token.to_s
      @chat_id = chat_id.to_s
      @http = http
    end

    def configured?
      token.present? && chat_id.present?
    end

    def deliver(text)
      return unless configured?

      response = post(text)
      return if response.code.start_with?("2")

      raise ::Telegram::DeliveryError, "Telegram rechazó el aviso (#{response.code})"
    rescue ::Telegram::DeliveryError
      raise
    rescue StandardError => error
      raise ::Telegram::DeliveryError, "No se pudo avisar por Telegram (#{error.class})"
    end

    private

    attr_reader :token, :chat_id, :http

    def post(text)
      uri = URI("https://api.telegram.org/bot#{token}/sendMessage")
      request = ::Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request.body = { chat_id: chat_id, text: text }.to_json

      http.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |connection|
        connection.request(request)
      end
    end
  end
end
