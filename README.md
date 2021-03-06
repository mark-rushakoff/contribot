# Contribot

[![Build Status](https://travis-ci.org/mark-rushakoff/contribot.png)](https://travis-ci.org/mark-rushakoff/contribot)

## Getting Started

Create a user to actually create comments.
If your user was octocat, run `rake token:generate[octocat]` (you will be prompted for octocat's password).
This will generate and display a token that is needed so that the app can comment on behalf of that user.

[Register an application on GitHub](https://github.com/settings/applications/new).
For development, you can set both the URL and callback URL to (e.g.) `http://localhost:3001`.

After registering your application, GitHub will supply you with a client ID and a client secret.
Set those to the respective environment variables `CONTRIBOT_GITHUB_CLIENT_ID` and `CONTRIBOT_GITHUB_CLIENT_SECRET`.
The [figaro gem](https://github.com/laserlemon/figaro) is included, so you can set those environment variables via `config/application.yml` like so:

```yaml
# config/application.yml
CONTRIBOT_GITHUB_CLIENT_ID: 'some_id'
CONTRIBOT_GITHUB_CLIENT_SECRET: 'some_secret'
CONTRIBOT_HOST: 'contribot.example.com'
CONTRIBOT_BOT_NAME: 'octocat'
CONTRIBOT_BOT_TOKEN: 'some_token'
```

Configure your application to watch a repository by running e.g. `rake repo:watch[octocat/foobar]`.
If you receive an error message about "No repository found for this hub.topic", that means that the user in CONTRIBOT_BOT_NAME is not a collaborator on that repository.

For this app to be useful, you need to set some GitHub users as administrators.
From the command line, you can run:

* `rake admin:add[octocat]` to mark user `octocat` as an admin.
* `rake admin:remove[octocat]` to remove user `octocat` from the list of admins.
* `rake admin:list` to print out a list of all the admins.

## Similar Projects

* [dredd](https://github.com/xoebus/dredd)
* [clabot](https://github.com/clabot/clabot)

## Contributing

If you make improvements to this application, please share with others.

* Fork the project on GitHub.
* Make your feature addition or bug fix.
* Commit with Git.
* Send the author a pull request.

If you add functionality to this application, create an alternative implementation, or build an application that is similar, please contact me and I'll add a note to the README so that others can find your work.

## License

Copyright 2013 Mark Rushakoff.

Available under the terms of the MIT license.
