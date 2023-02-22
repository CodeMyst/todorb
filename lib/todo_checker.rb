# frozen_string_literal: true

require 'colorize'

PATTERN = %r{(#|//|/\*|--)\s*(todo|fixme|warn)(\(.*\))?\b.*$}i.freeze

COMMENTS = ['#', '//', '/*', '--'].freeze

COLORS = {
  'todo' => :blue,
  'fixme' => :red,
  'warn' => :yellow
}.freeze

# Runs TODO comment checking on files and lines.
class TodoChecker
  # Runs TODO comment checking on a file, reporting all found TODO comments.
  def check_file(file)
    IO.foreach(file) { |line| check_line file, line }
  end

  private

  def check_line(file, line)
    if todo_comment?(line)
      type = line[PATTERN, 2].downcase

      puts
      print_filename file, $INPUT_LINE_NUMBER
      print_comment line, type

      @in_todo_comment = true
      @previous_type = type
    elsif @in_todo_comment && comment?(line)
      print_comment line, @previous_type
    else
      @in_todo_comment = false
    end

    @previous_line = line
  end

  # Check if the provided line is a comment (of any type).
  def comment?(line)
    line.strip.start_with?(*COMMENTS)
  end

  def todo_comment?(line)
    line.match(PATTERN)
  end

  # Prints a comment in color depending on the type.
  def print_comment(line, type)
    puts "\t#{line.strip.colorize(COLORS[type])}"
  end

  # Prints the file name and line number.
  def print_filename(file, line)
    puts "#{file[2..]}:#{line}"
  end
end
