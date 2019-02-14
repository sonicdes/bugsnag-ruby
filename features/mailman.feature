Feature: Bugsnag raises errors in Mailman

Background:
  Given I set environment variable "BUGSNAG_API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I set environment variable "APP_PATH" to "/usr/src"
  And I configure the bugsnag endpoint

Scenario Outline: An unhandled RuntimeError sends a report
  And I set environment variable "RUBY_VERSION" to "<ruby version>"
  And I set environment variable "TARGET_EMAIL" to "emails/unhandled.eml"
  And I start the service "mailman"
  And I wait for 1 seconds
  Then I should receive a request
  And the request used the "Ruby Bugsnag Notifier" notifier
  And the request used payload v4 headers
  And the request contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the event "unhandled" is true
  And the event "severity" equals "error"
  And the event "severityReason.type" equals "unhandledExceptionMiddleware"
  And the event "severityReason.attributes.framework" equals "Mailman"
  And the event "app.type" equals "mailman"
  And the exception "errorClass" equals "RuntimeError"

  Examples:
  | ruby version |
  | 2.0          |
  | 2.1          |
  | 2.2          |
  | 2.3          |
  | 2.4          |
  | 2.5          |

Scenario Outline: A handled RuntimeError sends a report
  And I set environment variable "RUBY_VERSION" to "<ruby version>"
  And I set environment variable "TARGET_EMAIL" to "emails/handled.eml"
  And I start the service "mailman"
  And I wait for 1 seconds
  Then I should receive a request
  And the request used the "Ruby Bugsnag Notifier" notifier
  And the request used payload v4 headers
  And the request contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the event "unhandled" is false
  And the event "severity" equals "warning"
  And the event "severityReason.type" equals "handledException"
  And the event "app.type" equals "mailman"
  And the exception "errorClass" equals "RuntimeError"

  Examples:
  | ruby version |
  | 2.0          |
  | 2.1          |
  | 2.2          |
  | 2.3          |
  | 2.4          |
  | 2.5          |