@homepage
Feature: As user bob I want to steal programs from another user

  Background:
    Given there are users:
      | name     | password | token      | email               |
      | catroweb | 123456   | cccccccccc | dev1@pocketcode.org |
      | bob      | 123456   | cccccccccc | dev2@pocketcode.org |
    And there are programs:
      | id | name      | description             | owned by | downloads | apk_downloads | views | upload time      | version | language version | visible | apk_ready |
      | 1  | program 1 | my superman description | catroweb | 3         | 2             | 12    | 01.01.2013 12:00 | 0.8.5   | 0.94             | true    | true      |
      | 2  | program 2 | catrowebs second prog   | catroweb | 333       | 3             | 9     | 22.04.2014 13:00 | 0.8.5   | 0.93             | true    | true      |
      | 3  | program 3 | a third prog            | catroweb | 333       | 3             | 9     | 04.06.2015 14:00 | 0.8.5   | 0.93             | true    | true      |

  Scenario: User bob should have a steal program button on his profile page
    Given I log in as "bob" with the password "123456"
    And I am on "/pocketcode/profile"
    Then I should see a "button#btn-steal-program" element

  Scenario: User catroweb should not have a steal program button on his profile page
    Given I log in as "catroweb" with the password "123456"
    And I am on "/pocketcode/profile"
    Then I should not see a "button#btn-steal-program" element

  Scenario: User bob should be able to steal a program from user catroweb
    Given I log in as "bob" with the password "123456"
    And I am on "/pocketcode/profile"
    And I wait for AJAX to finish
    And I should see "There are currently no programs"
    And I press "btn-steal-program"
    And I wait for AJAX to finish
    Then I should not see "There are currently no programs"
    And I should see 1 ".program" element

  Scenario: User bob should be able to steal multiple programs from user catroweb
    Given I log in as "bob" with the password "123456"
    And I am on "/pocketcode/profile"
    And I wait for AJAX to finish
    And I should see "There are currently no programs"
    And I press "btn-steal-program"
    And I wait for AJAX to finish
    Then I should not see "There are currently no programs"
    And I should see 1 ".program" element
    Then I press "btn-steal-program"
    And I wait for AJAX to finish
    Then I should see 2 ".program" element


#  The following tests don't work - test environment does redirect to home on error

#  Scenario: I should not be able to use an invalid CSRF token to steal a program
#    Given I log in as "bob" with the password "123456"
#    And I have a parameter "token" with value "invalid"
#    When I POST these parameters to "/pocketcode/profile/stealProgram"
#    Then the response status code should be 403

#  Scenario: User catroweb should not be able to steal a program
#    Given I log in as "catroweb" with the password "123456"
#    And I have a parameter "token" with value "maybe-valid"
#    When I POST these parameters to "/pocketcode/profile/stealProgram"
#    Then the response status code should be 403
