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

After Ruby style changes, run `QLTY FMT`.

## License

Released under the [MIT License](LICENSE).
