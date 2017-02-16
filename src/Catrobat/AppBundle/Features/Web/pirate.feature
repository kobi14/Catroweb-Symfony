@homepage
Feature:
  I am bob
  I am a pirate
  I steal programs from other users

  Background:
    Given there are users:
      | name     | password | token      | email               |
      | Catrobat | 123456   | cccccccccc | dev1@pocketcode.org |
      | bob      | 2234     | iiiiiiiiii | dev2@pocketcode.org |
    And there are programs:
      | id | name      | description | owned by | downloads | apk_downloads | views | upload time      | version |
      | 1  | program 1 | p1          | Catrobat | 3         | 2             | 12    | 01.01.2013 12:00 | 0.8.5   |
      | 2  | program 2 |             | Catrobat | 333       | 123           | 9     | 22.04.2014 13:00 | 0.8.5   |
      | 3  | program 3 |             | bob      | 133       | 63            | 33    | 01.01.2012 13:00 | 0.8.5   |

    And I log in as "bob" with the password "2234"
    And I am on "/pocketcode/profile"

  Scenario: see the special button
    Given I click the "edit" button
    And I wait for the server response
    Then I am on "/pocketcode/profile/edit?id=2"
    Then I see the "password-information"
    Then I see the "special-information"
    Then I see the "special-button"

  Scenario: can go to pirate page
    Given I click the "edit" button
    And I wait for the server response
    Then I see the "special-button"
    And I click the "special-button" button
    And I wait for the server response
    And I am on "/pocketcode/special"
    Then I see the "pirate-button"

  Scenario: catroweb cant see special button
    Given I log in as "Catrobat" with the password "123456"
    Given I am on "/pocketcode/profile"
    Given I click the "edit" button
    And I wait for the server response
    Then I see the "password-information"
    Then I dont see the "special-information"
    Then I dont see the "special-button"

