require_relative "../util/file_reader"

NO_OF_ITERATIONS = 10

class Day14
  def build_insertion_rules(input_array)
    insertion_rules = {}
    input_array.each { |insertion_rule|
      insertion_rule_pair = insertion_rule.split(" -> ")
      elements = insertion_rule_pair[0].split("")
      insertion_rules[insertion_rule_pair[0]] = "#{elements[0]}#{insertion_rule_pair[1]}"
    }
    insertion_rules
  end

  def substitute_polymer(polymer, insertion_rules)
    return insertion_rules[polymer] if polymer.length == 2
    "#{substitute_polymer(polymer[0..1], insertion_rules)}#{substitute_polymer(polymer[1...polymer.length], insertion_rules)}"
  end

  def polymerize(polymer_template, insertion_rules)
    (0...NO_OF_ITERATIONS).each { |iteration|
      puts "----------- Executing Iteration #{iteration}"
      length = polymer_template.length
      polymerized_result_left = substitute_polymer(polymer_template[0..length/2], insertion_rules)
      polymerized_result_right = substitute_polymer(polymer_template[length/2...length], insertion_rules)
      last_element = polymer_template[-1, 1]
      polymer_template = "#{polymerized_result_left}#{polymerized_result_right}#{last_element}"
    }
    polymer_template.split("")
  end

  def compute
    puts "Start time: #{Time.now}"
    input_file_content = FileReader.new.read("day14.txt")
    input_array = input_file_content.split("\n")
    polymer_template = input_array[0]
    insertion_rules = build_insertion_rules(input_array[2, input_array.size])
    polymerized_elements = polymerize(polymer_template, insertion_rules)
    sorted_elements_count = get_sorted_elements_with_count(polymerized_elements)
    puts "End time: #{Time.now}"
    sorted_elements_count.last - sorted_elements_count.first
  end

  private

  def get_sorted_elements_with_count(polymerized_elements)
    elements_count = {}
    polymerized_elements.each { |element|
      elements_count[element] = elements_count.has_key?(element) ? elements_count[element] + 1 : 0
    }
    elements_count.values.sort
  end
end

result = Day14.new.compute
puts result
