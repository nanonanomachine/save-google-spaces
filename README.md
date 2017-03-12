save-google-spaces
==================

Save your precious messages in [Google Spaces](https://spaces.google.com/).
Spaces will be discontinued on [April 17th](https://support.google.com/spaces/?p=web_default).Let's hurry up!

Capybara and selenium-webdriver(chromedriver) are used to achieve that.

This script will create directories of each space. Then logs named with numeric number are created in these directories.

Installation
------------

You need to install chromedriver.
Mac with homebrew:

```sh
$ brew install chromedriver
```

Then exec `bundle install`.

Usage
-----

1. Set your Google account info(EMAIL, PASSWORD) in app.rb.
  * You also need to change `BUTTON_NEXT`, `FILL_IN_PASSWORD`, `BUTTON_LOGIN` if your browser language is not English.
2. Run `app.rb`. Don't forget to pass directory path.

For example:

```sh
$ ruby app.rb /tmp/spaces_logs
```
