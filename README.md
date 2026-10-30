# Profe Axel

Personal training site. Rails, PostgreSQL, Tailwind CSS, and Stimulus.

## Getting started

```sh
bin/setup
bin/dev
```

The site is available at http://localhost:3000.

In development, the content admin credentials are:

- Email: `axel@profeaxel.cl`
- Password: the value of `ADMIN_PASSWORD`, or `profe-axel-dev` when that variable is unset

In other environments the account is created only when `ADMIN_PASSWORD` is set.

## Telegram alerts

Set both variables so Axel gets a message each time someone requests an evaluation. The form still saves when they are missing or Telegram does not answer.

- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`

Create the bot with [@BotFather](https://t.me/BotFather), open the bot and send it any message, then read the chat id from `https://api.telegram.org/bot<token>/getUpdates`.

After Ruby style changes, run `QLTY FMT`.

## License

Released under the [MIT License](LICENSE).
