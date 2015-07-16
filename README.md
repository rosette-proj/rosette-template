rosette-template
========

A working Rosette example setup.

## Prerequisites

1. [Java JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html), there should be a pre-packaged installer available for your operating system.
2. [JRuby 1.7.15](http://jruby.org/), usually best to install via a version manager like [rvm](https://rvm.io/).
3. [Bundler](http://bundler.io/), usually as simple as `gem install bundler`.
4. [MySQL](https://www.mysql.com/), usually available via your operating system's package manager, like [Homebrew](http://brew.sh/) on Mac OS (`brew install mysql`).
5. [Redis](http://redis.io/), also available via your package manager (Mac OS: `brew install redis`).

## Setup

1. Clone this repository.
2. Change directory into your local clone.
3. Run `bundle install` to install gem dependencies.
4. Run `bundle exec expert install` to install Java dependencies.
5. Run `git clone git@github.com:rosette-proj/rosette-demo-rails-app ./workspace/rosette-demo-rails-app` to clone the demo app into the workspace.
6. Create a mysql database called `rosette` and a mysql user also called `rosette` with password `rosette-dev`.
7. Run `bundle exec rake db:setup db:migrate` to create the necessary database tables.
8. Run `bundle exec rake build_history` to extract phrases from all commits in rosette-demo-rails-app.
9. Run `bundle exec translations:import` to automatically generate fake translations (for demo purposes).
10. Run `bundle exec foreman start` to start the project's various services.

If all is well, you should be able to visit [http://localhost:8080/v1/alive.json](http://localhost:8080/v1/alive.json) and see a plaintext response of `true`.

You should also be able to visit [http://localhost:8080/resque](http://localhost:8080/resque) and see the [resque](https://github.com/resque/resque) admin interface.

## Environment Variables

This Rosette demo requires a few environment variables, which should be stored in a file called `.env`. Copy the example (`.env.example`) to `.env` and edit the contents. The variables will be loaded at runtime by the [dotenv](https://github.com/bkeepers/dotenv) gem.

Specifically the environment contains:

1. A username and password for the resque admin interface.
2. Your github webhook secret. This is not strictly necessary for the purposes of the demo, you can leave it blank.

## Important Files

Rosette is configured to know about the rosette-demo-rails-app in `./workspace` and how to extract phrases from its commits. The configuration is plain 'ol (heavily commented) Ruby code and lives in `lib/config.rb`. Database connection configuration can be found in `lib/database.yml`.

All rake tasks live in `tasks/`.

## Usage

Now that you've got Rosette running, processed some commits, and added some translations, you can explore what she knows via her HTTP API.

### Locales

Point your browser to `http://localhost:8080/v1/swagger_doc`. You should see a JSON response listing the top-level endpoints Rosette supports. Notice the one whose path is "/locales.{format}". Pointing your browser at `http://localhost:8080/v1/swagger_doc/locales` will show you the necessary parameters and such necessary for using the "locales" endpoint. By manipulating the URL in your browser, you will be able to browse all of Rosette's API documentation.

### Git Commands

When Rosette extracts translatable phrases from a git commit, it associates the commit id with the phrases. This means you can ask Rosette which phrases existed for any of the commits in the repository. Specifically this information is used to power Rosette's git commands.

For example, to show the phrases that changed in the most recent commit, visit this URL in your browser:

[http://localhost:8080/v1/git/show.json?repo_name=rosette-demo-rails-app&ref=HEAD](http://localhost:8080/v1/git/show.json?repo_name=rosette-demo-rails-app&ref=HEAD)

Rosette will show you that 14 new phrases were added in the most recent commit (called the HEAD).

Check out the API docs (described above) for a complete list of git commands you can run (hint: here's the [complete list](http://localhost:8080/v1/swagger_doc/git).)

## Exporting Translations

Exporting is just about as easy as the git commands. Try this:

[http://localhost:8080/v1/translations/export.json?repo_name=rosette-demo-rails-app&ref=master&serializer=yaml/rails&locale=en-LC](http://localhost:8080/v1/translations/export.json?repo_name=rosette-demo-rails-app&ref=master&serializer=yaml/rails&locale=en-LC)

This will show you an export of all the translations found for the master branch in the LOLCAT locale (en-LC). The export should be in YAML format because we asked the exporter to use the yaml/rails serializer.

All the necessary parameters for the export endpoint are documented [here](http://localhost:8080/v1/swagger_doc/translations). As an exercise, see if you can export the translations for the en-PL locale (pig latin).

## More Information

Check out our introduction site at [https://rosette-proj.github.io](https://rosette-proj.github.io).

Rosette is made up of a bunch of different modules that can be composed together. See [https://github.com/rosette-proj](https://github.com/rosette-proj) for a full list.

Yard docs for [rosette-core](https://github.com/rosette-proj/rosette-core) are available [here](http://www.rubydoc.info/github/rosette-proj/rosette-core/master/index).

## Authors

* Cameron C. Dutro: http://github.com/camertron
