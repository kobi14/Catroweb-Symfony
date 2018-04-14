@homepage
Feature:
  In order to manage the my profile page
  As a logged in user
  I want to be able to steal programs from catroweb user

  Background:
    Given there are users:
      | name     | password | token      | email               |
      | catroweb | 123456   | cccccccccc | dev1@pocketcode.org |
      | catrobat | 123456   | cccccccccc | dev2@pocketcode.org |
      | stephan  | 654321   | cccccccccc | dev3@pocketcode.org |
    And there are programs:
      | id | name      | description | owned by | downloads | apk_downloads | views | upload time      | version |
      | 1  | program 1 | p1          | catroweb | 3         | 2             | 12    | 01.01.2013 12:00 | 0.8.5   |
      | 2  | program 2 |             | catroweb | 333       | 123           | 9     | 22.04.2014 13:00 | 0.8.5   |
      | 3  | program 3 |             | catroweb | 133       | 63            | 33    | 01.01.2012 13:00 | 0.8.5   |

    And I log in as "catroweb" with the password "123456"
    And I am on "/pocketcode/profile"

  Scenario: all users different to stephan should not see the steal button
    Given I should not see an ".steal-button" element
    When I go to "/logout"
    And I log in as "catrobat" with the password "123456"
    And I am on "/pocketcode/profile"
    And I should not see an ".steal-button" element
    When I go to "/logout"
    And I log in as "stephan" with the password "654321"
    And I am on "/pocketcode/profile"
    Then I should see an ".steal-button" element

  Scenario: stephan steal a program from catroweb
    Given I wait for a second
    Then I should see "program 1"
    When I go to "/logout"
    And I log in as "stephan" with the password "654321"
    And I am on "/pocketcode/profile"
    And I click the "steal" button
    And I wait for the server response
    And I wait for a second
    Then I should see "program 1"
    When I go to "/logout"
    And I log in as "catrobat" with the password "123456"
    And I am on "/pocketcode/profile"
    And I wait for a second
    Then I should not see "program 1"