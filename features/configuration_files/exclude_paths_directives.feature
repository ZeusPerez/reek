Feature: Exclude paths directives
  In order to avoid Reek wasting time on files that cannot be fixed
  As a user
  I want to be able to exclude specific paths from being checked

  Scenario: Exclude some paths
    Given a file named "bad_files_live_here/smelly.rb" with:
      """
      # A smelly example class
      class Smelly
        def alfa(bravo); end
      end
      """
    When I run reek .
    Then the exit status indicates smells
    Given a file named "config.reek" with:
      """
      ---
      exclude_paths:
        - bad_files_live_here
      """
    When I run reek -c config.reek .
    Then it succeeds
    And it reports nothing

  Scenario: Exclude single file
    Given a file named "bad_files_live_here/smelly1.rb" with:
      """
      # Smelly class 1
      class Smelly
        # This will reek of UncommunicativeMethodName
        def x
        end
      end
      """
    And a file named "bad_files_live_here/smelly2.rb" with:
      """
      # Smelly class 2
      class Smelly
        def foobar
          y = 10 # This will reek of UncommunicativeVariableName
        end
      end
      """
    And a file named "config.reek" with:
      """
      ---
      exclude_paths:
        - bad_files_live_here/smelly1.rb
      """
    When I run reek -c config.reek .
    Then the exit status indicates smells
    And it reports:
      """
      bad_files_live_here/smelly1.rb -- 1 warning:
        [4]:UncommunicativeMethodName: Smelly#x has the name 'x'
      """

  Scenario: Using a file name within an excluded directory
    Given a file named "bad_files_live_here/smelly.rb" with:
      """
      # A smelly example class
      class Smelly
        def alfa(bravo); end
      end
      """
    And a file named "config.reek" with:
      """
      ---
      exclude_paths:
        - bad_files_live_here
      """
    When I run reek -c config.reek bad_files_live_here/smelly.rb
    Then the exit status indicates smells
    When I run reek -c config.reek --force-exclusion bad_files_live_here/smelly.rb
    Then it succeeds
    And it reports nothing
