module Enumerable
  def around(index_or_range, &block)
    left, right = case index_or_range
    in Range => r then [[r.min - 1, 0].max, (r.max + 1)]
    in Numeric => i then [[i - 1, 0].max, (i + 1)]
    end

    drop(left).take(right - left + 1).each(&block)
  end
end

grid = File.readlines(ARGV[0], chomp: true)

sum = 0
gear_parts = Hash.new { |hash, key| hash[key] = [] }

grid.each_with_index do |line, y|
  offset = 0
  loop do
    match = line.match(/\d+/, offset) or break
    left, right = match.begin(0), match.end(0)
    offset = right
    num = match.to_s.to_i

    # Part 1
    has_adjacent_symbol = grid.around(y).any? do |adjacent_line|
      adjacent_line.chars.around(left...right).to_a.join.match?(/[^\d\.]/)
    end
    sum += num if has_adjacent_symbol

    # Part 2
    grid.each_with_index.around(y) do |adjacent_line, y|
      _, x = adjacent_line
        .chars
        .each_with_index
        .around(left...right)
        .find { |c, _| c == '*' }

      break gear_parts[[y, x]] << num if x
    end
  end
end

p sum
p gear_parts.values
  .filter { |ps| ps.length == 2 }
  .map { |ps| ps.reduce(&:*) }
  .sum
