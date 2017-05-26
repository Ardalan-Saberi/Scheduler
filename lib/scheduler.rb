module Scheduler
  class CircularDependencyException < Exception
  end

  ##
  # converts dependency hash into a proper graph representatios then
  # picks independent tasks in the hash and removes them from other
  # taks' dependenceis until hash is empty.
  # if there are no more independent tasks and hash is not empty, 
  # raises CircularDependencyException
  def schedule(dependecny_hash)
    puts "-------------------"
    puts "test case: #{dependecny_hash}"
    graph = add_independent_nodes(dependecny_hash)
    
    result = []

    while !graph.empty? 
      if (independent_task = fetch_independent_task(graph)).nil?
        fail CircularDependencyException
      end
      result << independent_task
      remove_dependencies(graph, independent_task)
    end 

    puts "returned: #{result}"
    result
  end
  
  ##
  # the only difference between dependency hash representation and
  # a graph was that it lacked the independent nodes (starting nodes)
  # this will add them back
  # for example maps {"A"=>["B"]} to {"A"=>["B"], "B"=>[]}
  def add_independent_nodes(dependency_hash)
    result = {}
    
    dependency_hash.each do |task, dependencies|
      result[task] = result.fetch(task, []) + dependencies
      
      dependencies.each do |dependent_task|
        if !result[dependent_task]
          result[dependent_task] = []
        end
      end
    end

    result
  end

  def remove_dependencies(dependecny_hash, task_to_remove)
    dependecny_hash.each do |task, dependencies|
      dependencies.delete(task_to_remove)
    end
    dependecny_hash.delete(task_to_remove)
  end

  def fetch_independent_task(dependecny_hash)
  
    dependecny_hash.each do |task, dependencies|
      return task if dependencies.empty?
    end

    nil
  end

  module_function :schedule, 
                  :add_independent_nodes, 
                  :remove_dependencies, 
                  :fetch_independent_task
end

