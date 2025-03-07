# Decidim::Patches

[![Build Status](https://github.com/mainio/decidim-module-patches/actions/workflows/ci_patches.yml/badge.svg)](https://github.com/mainio/decidim-module-patches/actions)
[![codecov](https://codecov.io/gh/mainio/decidim-module-patches/branch/master/graph/badge.svg)](https://codecov.io/gh/mainio/decidim-module-patches)

A [Decidim](https://github.com/decidim/decidim) module that contains important
patches that are not included in the official releases. Using this module, we
can continue maintaining older versions that no longer receive official updates.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-patches"
```

And then execute:

```bash
$ bundle
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
$ SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
