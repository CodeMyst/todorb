#!/usr/bin/env ruby

# frozen_string_literal: true

require 'colorize'
require 'English'
require 'ptools'

PATTERN = %r{(#|//|/\*|--)\s*(todo|fixme|note)(\(.*\))?:.*$}i.freeze

COMMENTS = ['#', '//', '/*', '--'].freeze

COLORS = {
  'todo' => :blue,
  'fixme' => :red,
  'note' => :cyan
}.freeze

# TODO: test todo
# FIXME: fixme!!!
# NOTE: hmmm

# TODO: This todo spans
# multiple lines, quite complex!!!

# TODO(#123): With issue number!

# Recursively finds all files in the glob pattern and runs a block on each file.
def each_file(glob, &block)
  Dir[glob].reject { |e| File.directory?(e) || File.binary?(e) }.each(&block)
end

# Check if the provided line is a TODO comment.
def todo_comment?(line)
  !line.nil? && line.match(PATTERN)
end

# Check if the provided line is a comment (of any type).
def comment?(line)
  line.strip.start_with?(*COMMENTS)
end

# Prints a comment in color depending on the type.
def print_comment(line, type)
  puts "\t#{line.strip.colorize(COLORS[type])}"
end

# Prints the file name and line number.
def print_filename(file, line)
  puts "#{file[2..]}:#{line}"
end

each_file('./**/*') do |file|
  previous_line = nil
  previous_type = nil

  IO.foreach(file) do |line|
    if (match = line.match(PATTERN))
      puts

      type = match.captures[1].downcase

      print_filename file, $INPUT_LINE_NUMBER
      print_comment line, type

      previous_type = type
    elsif todo_comment?(previous_line) && comment?(line)
      print_comment line, previous_type
    end

    previous_line = line
  end
end

puts
