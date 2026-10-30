require "test_helper"

class NotifyEvaluationRequestJobTest < ActiveSupport::TestCase
  test "ignores a request that was removed" do
    assert_nil NotifyEvaluationRequestJob.perform_now(-1)
  end

  test "finishes when Telegram is not configured" do
    request = EvaluationRequest.create!(
      name: "Camila Soto",
      phone: "+56912345678",
      email: "camila@example.com",
      goal: "fuerza",
      modality: "online",
      preferred_on: Date.current + 2,
      preferred_time: "noche",
      message: "Entreno hace un año.",
      consent: true
    )
    previous = clear_telegram_env

    assert_nothing_raised { NotifyEvaluationRequestJob.perform_now(request.id) }
  ensure
    restore_telegram_env(previous)
  end

  private

  def clear_telegram_env
    previous = {
      "TELEGRAM_BOT_TOKEN" => ENV["TELEGRAM_BOT_TOKEN"],
      "TELEGRAM_CHAT_ID" => ENV["TELEGRAM_CHAT_ID"]
    }
    ENV.delete("TELEGRAM_BOT_TOKEN")
    ENV.delete("TELEGRAM_CHAT_ID")
    previous
  end

  def restore_telegram_env(previous)
    return if previous.blank?

    previous.each do |key, value|
      value.nil? ? ENV.delete(key) : ENV[key] = value
    end
  end
end
