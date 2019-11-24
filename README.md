# DataCite re3data internal API

[![Build Status](https://travis-ci.org/datacite/schnauzer.svg?branch=master)](https://travis-ci.org/datacite/schnauzer) [![Maintainability](https://api.codeclimate.com/v1/badges/4032e94f759b56d71885/maintainability)](https://codeclimate.com/github/datacite/schnauzer/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/4032e94f759b56d71885/test_coverage)](https://codeclimate.com/github/datacite/schnauzer/test_coverage)

## Installation


Using Docker.

```bash
docker run -p 8055:80 datacite/schnauzer
```

or

```bash
docker-compose up
```

You can now point your browser to `http://localhost:8055` and use the application. Most API endpoints require authentication.

## Development

We use Rspec for testing:

```bash
bundle exec rspec
```

Follow along via [Github Issues](https://github.com/datacite/schnauzer/issues).

### Note on Patches/Pull Requests

* Fork the project
* Write tests for your new feature or a test that reproduces a bug
* Implement your feature or make a bug fix
* Do not mess with Rakefile, version or history
* Commit, push and make a pull request. Bonus points for topical branches.

## License

**Schnauzer** is released under the [MIT License](https://github.com/datacite/schnauzer/blob/master/LICENSE).

