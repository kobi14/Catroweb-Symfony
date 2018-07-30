@api
Feature: Register a new account with the api

  Background:
    Given there are users:
      | name     | password | token      | dn           | email             |
      | Catrobat | 123456   | cccccccccc |              | test@testmail.at  |
      | LDAP-user|          | cccccccccc | cn=LDAP-user |                   |

  Scenario: Try to register a user who is missing the username
    Given the next generated token will be "rrrrrrrrrrr"
    And I have the POST parameters:
      | name                 | value                |
      | registrationUsername |                      |
      | registrationPassword | registrationpassword |
      | registrationEmail    | test@mail.com        |
    When I POST these parameters to "/pocketcode/api/register/Register.json"
    Then I should get the json object:
      """
      {"statusCode":762,"answer":"Username must not be blank.","preHeaderMessages":""}
      """

  Scenario: Try to register a user who has an invalid user name
    Given the next generated token will be "rrrrrrrrrrr"
    And I have the POST parameters:
      | name                 | value                |
      | registrationUsername | username@            |
      | registrationPassword | registrationpassword |
      | registrationEmail    | test@mail.com        |
    When I POST these parameters to "/pocketcode/api/register/Register.json"
    Then I should get the json object:
      """
      {"statusCode":764,"answer":"Your username is invalid.","preHeaderMessages":""}
      """

  Scenario: Try to register a user whos name already exists
    Given the next generated token will be "rrrrrrrrrrr"
    And I have the POST parameters:
      | name                 | value                |
      | registrationUsername | Catrobat             |
      | registrationPassword | registrationpassword |
      | registrationEmail    | test@mail.com        |

    When I POST these parameters to "/pocketcode/api/register/Register.json"
    Then I should get the json object:
      """
      {"statusCode":777,"answer":"This username already exists.","preHeaderMessages":""}
      """

  Scenario: Try to register a user who is missing the password
    Given the next generated token will be "rrrrrrrrrrr"
    And I have the POST parameters:
      | name                 | value                |
      | registrationUsername | testusername         |
      | registrationPassword |                      |
      | registrationEmail    | test@mail.com        |
    When I POST these parameters to "/pocketcode/api/register/Register.json"
    Then I should get the json object:
      """
      {"statusCode":751,"answer":"The password is missing.","preHeaderMessages":""}
      """

  Scenario: Try to register a user who has a password that is too short.
    Given the next generated token will be "rrrrrrrrrrr"
    And I have the POST parameters:
      | name                 | value                |
      | registrationUsername | testusername         |
      | registrationPassword | test                 |
      | registrationEmail    | test@mail.com        |
    When I POST these parameters to "/pocketcode/api/register/Register.json"
    Then I should get the json object:
      """
      {"statusCode":753,"answer":"Your password must have at least 6 characters.","preHeaderMessages":""}
      """

  Scenario: Try to register a user who has not set an email adress.
    Given the next generated token will be "rrrrrrrrrrr"
    And I have the POST parameters:
      | name                 | value                |
      | registrationUsername | testusername         |
      | registrationPassword | registrationpassword |
      | registrationEmail    |                      |
    When I POST these parameters to "/pocketcode/api/register/Register.json"
    Then I should get the json object:
      """
      {"statusCode":778,"answer":"Email must not be blank!","preHeaderMessages":""}
      """

  Scenario: Try to register a user who has set an invalid email adress.
    Given the next generated token will be "rrrrrrrrrrr"
    And I have the POST parameters:
      | name                 | value                |
      | registrationUsername | testusername         |
      | registrationPassword | registrationpassword |
      | registrationEmail    | testmailcom          |
    When I POST these parameters to "/pocketcode/api/register/Register.json"
    Then I should get the json object:
      """
      {"statusCode":765,"answer":"Your email seems to be invalid.","preHeaderMessages":""}
      """

  Scenario: Try to register a user who set an email adress that is currently in use.
    Given the next generated token will be "rrrrrrrrrrr"
    And I have the POST parameters:
      | name                 | value                |
      | registrationUsername | testusername         |
      | registrationPassword | registrationpassword |
      | registrationEmail    | test@testmail.at     |
    When I POST these parameters to "/pocketcode/api/register/Register.json"
    Then I should get the json object:
      """
      {"statusCode":757,"answer":"This email address already exists.","preHeaderMessages":""}
      """

  Scenario: Successful registration of a user.
    Given the next generated token will be "rrrrrrrrrrr"
    And I have the POST parameters:
      | name                 | value                |
      | registrationUsername | testusername         |
      | registrationPassword | registrationpassword |
      | registrationEmail    | test1@testmail.at     |
    When I POST these parameters to "/pocketcode/api/register/Register.json"
    Then I should get the json object:
      """
      {"statusCode":201,"answer":"Registration successful!","token":"rrrrrrrrrrr","preHeaderMessages":""}
      """