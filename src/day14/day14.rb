require_relative "../util/file_reader"

NO_OF_ITERATIONS = 40

class Day14
  def build_insertion_rules(input_array)
    insertion_rules = {}
    input_array.each { |insertion_rule|
      insertion_rule_pair = insertion_rule.split(" -> ")
      insertion_rules[insertion_rule_pair[0]] = insertion_rule_pair[1]
    }
    insertion_rules
  end

  def build_pairwise_map(polymer_elements)
    pairwise_map = {}
    elements_count = {}
    no_of_polymer_elements = polymer_elements.length
    (0...(no_of_polymer_elements - 1)).each { |index|
      formula = "#{polymer_elements[index]}#{polymer_elements[index + 1]}"
      pairwise_map[formula] = value_of(formula, pairwise_map)
      elements_count[polymer_elements[index]] = value_of(polymer_elements[index], elements_count)
    }
    elements_count[polymer_elements[no_of_polymer_elements - 1]] = value_of(polymer_elements[no_of_polymer_elements - 1], elements_count)
    puts pairwise_map
    puts elements_count
    [pairwise_map, elements_count]
  end

  def value_of(element, hash)
    hash.has_key?(element) ? hash[element] + 1 : 1
  end

  def polymerize(polymer_template, insertion_rules)
    polymer_elements = polymer_template.split("")
    pairwise_map_with_count = build_pairwise_map(polymer_elements)
    pairwise_map = pairwise_map_with_count[0]
    elements_count = pairwise_map_with_count[1]
    (0...NO_OF_ITERATIONS).each { |iteration|
      puts "---------- Executing Iteration #{iteration + 1}"
      polymerized_map = {}
      pairwise_map.each { |k, count|
        insertion_element = insertion_rules[k]
        elements = k.split("")

        first_polymer = "#{elements[0]}#{insertion_element}"
        second_polymer = "#{insertion_element}#{elements[1]}"
        polymerized_map[first_polymer] = value_of(first_polymer, polymerized_map) + (count-1)
        polymerized_map[second_polymer] = value_of(second_polymer, polymerized_map) + (count-1)
        elements_count[insertion_element] = value_of(insertion_element, elements_count) + (count-1)
      }
      pairwise_map = polymerized_map
    }
    elements_count
  end

  def compute
    puts "Start time: #{Time.now}"
    input_file_content = FileReader.new.read("day14.txt")
    input_array = input_file_content.split("\n")
    polymer_template = input_array[0]
    insertion_rules = build_insertion_rules(input_array[2, input_array.size])
    polymerized_elements_count = polymerize(polymer_template, insertion_rules)
    sorted_elements_count = polymerized_elements_count.values.sort
    puts "End time: #{Time.now}"
    sorted_elements_count.last - sorted_elements_count.first
  end
end

result = Day14.new.compute
puts result
