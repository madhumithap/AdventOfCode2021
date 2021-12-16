require_relative "../util/file_reader"

NO_OF_ITERATIONS = 10

class Day14
  def build_insertion_rules(input_array)
    insertion_rules = {}
    input_array.each { |insertion_rule|
      insertion_rule_pair = insertion_rule.split(" -> ")
      insertion_rules[insertion_rule_pair[0]] = insertion_rule_pair[1]
    }
    insertion_rules
  end

  def polymerize(polymer_template, insertion_rules)
    polymer_elements = polymer_template.split("")
    (0...NO_OF_ITERATIONS).each { |iteration|
      polymerization_result = []
      no_of_polymer_elements = polymer_elements.length
      (0...(no_of_polymer_elements - 1)).each { |index|
        insertion_element = insertion_rules["#{polymer_elements[index]}#{polymer_elements[index + 1]}"]
        insertion_position = index * 2
        polymerization_result[insertion_position] = polymer_elements[index]
        polymerization_result[insertion_position + 1] = insertion_element
      }
      polymerization_result[(no_of_polymer_elements - 1) * 2] = polymer_elements[no_of_polymer_elements - 1]
      polymer_elements = polymerization_result
    }
    polymer_elements
  end

  def compute
    input_file_content = FileReader.new.read("day14.txt")
    input_array = input_file_content.split("\n")
    polymer_template = input_array[0]
    insertion_rules = build_insertion_rules(input_array[2, input_array.size])
    polymerized_elements = polymerize(polymer_template, insertion_rules)
    sorted_elements_count = get_sorted_elements_with_count(polymerized_elements)
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
