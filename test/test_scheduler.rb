class TestScheduler < MiniTest::Test
  VALID_TEST_CASES = [
    { # example test case #1
      "A" => ["B"],
      "B" => ["C", "D", "E"],
      "F" => ["D"],
      "G" => ["B", "F"],
      "H" => ["F", "E"],
      },
    { # example test case #2
      "A" => ["C", "D"],
      "B" => ["D", "E"],
      "C" => ["F"],
      "E" => ["F"]
      },
    { # example test case #3
      "A" => ["B"]
      }, 
    { # one node with no dependencies
      "A" => []
      }, 
    { # empty dependency list case

      }, 
    { # same as discussed in the interview - disconnected dependencies
      "D" => ["E"],
      "Q" => ["R"],
      "A" => ["B", "C"],
      "B" => ["D", "C"],
      "P" => ["Q"]
    },
    { # example test case #4
      "A" => ["B", "C", "D"],
      "B" => ["C"],
      "C" => ["G"],
      "D" => ["E"],
      "E" => ["F"],
      "G" => ["F"],
      "H" => ["F"]
    }
  ]

  CIRCULAR_DEPENDENCY_TEST_CASES = [
    { # case with cyclce
      "D" => ["E", "F"],
      "F" => ["G", "B"],
      "A" => ["B"],
      "B" => ["C"],
      "C" => ["A"],
      },
    { # case with cyclce
      "A" => ["A"]
      },
    { # case with cyclce
      "A" => ["B"],
      "B" => ["A"]
    }
  ]

  def test_scheduler
    VALID_TEST_CASES.each do |test_case|
      assert(
        is_schedule_correct?(
          test_case,
          Scheduler.schedule(test_case)), 
        "Worng order!")
    end
  end

  def test_scheduler_circular_dependency_cases
    CIRCULAR_DEPENDENCY_TEST_CASES.each do |test_case|
      assert_raises(Scheduler::CircularDependencyException) { Scheduler.schedule(test_case) }
    end
  end

  private
  
  ##
  # starting with the first task in schedule, for all tasks
  # removes it from the dependency hash if there's no outstanding dependencies on it 
  # returns true indicating correct schedule if above ends up with empty hash
  # otherwise will return false indicating incorrect schedule

  def is_schedule_correct?(dependency_hash, schedule)
    dependency_hash = dependency_hash.dup
    schedule =  schedule.dup

    schedule.each do |task|
      if dependency_hash.empty?
        return true
      else
        if dependency_hash[task] && !dependency_hash[task].empty? 
          return false
        else
          ##
          # for all dependencies, removes task from depency list
          # if dependency list is empty, will remove dependant key as well
          dependency_hash.reject! do |key, dependecies|
            dependecies.delete(task)
            dependecies.empty? 
          end
        end
      end
    end
  end
end