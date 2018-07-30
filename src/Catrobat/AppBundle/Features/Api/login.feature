@api
Feature: Login an existing account with the api

  Background:
    Given there are users:
      | name     | password | token      | dn           | email             |
      | Catrobat | 123456   | cccccccccc |              | test@testmail.at  |
      | LDAP-user|          | cccccccccc | cn=LDAP-user |                   |
    And there are LDAP-users:
      | name                    | password  |
      | LDAP-user               | 654321    |


  Scenario: Login with valid username and password
    Given I have the POST parameters:
      | name                  | value                 |
      | loginUsername         | Catrobat              |
      | loginPassword         | 123456                |
    And the next generated token will be "cccccccccc"
    When I POST these parameters to "/pocketcode/api/login/Login.json"
    Then I should get the json object:
      """
      {"token":"cccccccccc","statusCode":200,"preHeaderMessages":"","email":"test@testmail.at", "nolbUser":false}
      """

  Scenario: Login with invalid username and valid password
    Given I have the POST parameters:
      | name                  | value                 |
      | loginUsername         |                       |
      | loginPassword         | 123456                |
    And the next generated token will be "cccccccccc"
    When I POST these parameters to "/pocketcode/api/login/Login.json"

    Then I should get the json object:
      """
      {"statusCode":762,"answer":"Username must not be blank.", "preHeaderMessages":""}
      """

  Scenario: Login with non existing username
    Given I have the POST parameters:
      | name                  | value                 |
      | loginUsername         | invalid               |
      | loginPassword         | 123456                |
    And the next generated token will be "cccccccccc"
    When I POST these parameters to "/pocketcode/api/login/Login.json"
    Then I should get the json object:
      """
      {"statusCode":764,"answer":"This username does not exist.", "preHeaderMessages":""}
      """

  Scenario: Login with invalid password
    Given I have the POST parameters:
      | name                  | value                 |
      | loginUsername         | Catrobat              |
      | loginPassword         | invalid               |
    And the next generated token will be "cccccccccc"
    When I POST these parameters to "/pocketcode/api/login/Login.json"
    Then I should get the json object:
      """
      {"statusCode":601,"answer":"The password or username was incorrect.", "preHeaderMessages":""}
      """
  Scenario: Login with invalid password
    Given I have the POST parameters:
      | name                  | value                 |
      | loginUsername         | Catrobat              |
      | loginPassword         |                       |

    And the next generated token will be "cccccccccc"
    When I POST these parameters to "/pocketcode/api/login/Login.json"
    Then I should get the json object:
      """
      {"statusCode":751,"answer":"The password is missing.", "preHeaderMessages":""}
      """