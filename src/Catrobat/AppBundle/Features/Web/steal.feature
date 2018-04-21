@homepage
Feature: Steal feature on program page

  Background:
    Given there are users:
      | name      | password | token       | email               |
      | Catrobat  | 123456   | cccccccccc  | dev1@pocketcode.org |
      | Catrobat2 | 123457   | cccccccccd  | dev2@pocketcode.org |

    And there are programs:
      | id | name      | description | owned by   | downloads | apk_downloads | views | upload time      | version | remix_root |
      | 1  | Minions   | p1          | Catrobat2  | 3         | 2             | 12    | 01.01.2013 12:00 | 0.8.5   | true       |

  Scenario: Steal Button should be visible on the program page
    Given I 0 log in as "Catrobat" with the password "123456"
    And I am on "/pocketcode/program/1"
    Then I should see an "#apk-steal" element

  Scenario: User is logged in and should be stealing Program
    Given I 0 log in as "Catrobat" with the password "123456"
    And I am on "/pocketcode/program/1"
    Then I click "#apk-steal"
    Then "Catrobat" should be owner of program with id "1"
    And I should be on "/pocketcode/program/1"
    And I should not see an "#apk-steal" element

  Scenario: User is owner of Program and Button should be not existent
    Given I 0 log in as "Catrobat2" with the password "123457"
    And I am on "/pocketcode/program/1"
    Then I should not see an "#apk-steal" element

  Scenario: User is not logged in and Button should be not existent
    Given I am on "/pocketcode/program/1"
    Then I should not see an "#apk-steal" element