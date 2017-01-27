Feature: Installation with `-e' option

  Scenario: describes `-e' option in the `install' command usage
    When I successfully run `localeapp help install`
    Then the output must match /-e.*--\[no-\]write-env-file.*write API key to/i

  Scenario: writes API key to `.env' file when given `-e' option
    Given I have a valid project on localeapp.com with api key "MYAPIKEY"
    When I successfully run `localeapp install MYAPIKEY -e`
    Then the file ".env" must contain exactly:
      """
      LOCALEAPP_API_KEY=MYAPIKEY
      """
