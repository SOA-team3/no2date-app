# No2Date App

Web application for No2Date system that allows teams to share sensitive files such as configuration information, credentials, etc.
No2date is is an online calendar tool aimed at facilitating event coordination among multiple participants. It enables individuals to indicate their available times and dates, as well as view the availability of others. This helps the group collectively determine a mutually convenient meeting time.
Web application for No2Date system that allows people to facilitate event coordination among multiple participants. It enables individuals to indicate their available times and dates, as well as view the availability of others. This helps the group collectively determine a mutually convenient meeting time.

Please also note the Web API that it uses: https://github.com/ISS-Security/No2Date-api

## Install

Install this application by cloning the *relevant branch* and use bundler to install specified gems from `Gemfile.lock`:

```shell
bundle install
```

## Test

This web app does not contain any tests yet :(

## Execute

Launch the application using:

```shell
rake run:dev
```

The application expects the API application to also be running (see `config/app.yml` for specifying its URL)
