#!/usr/bin/env ruby

# frozen_string_literal: true

# TODO: This is a todo!

# FIXME: This is a fixme!
# A really long...
# long...
# comment

# WARN: This is a warning!

# TODO

# TODO(#123): TODO with a ticket number attached!

require 'colorize'
require 'English'
require 'filemagic'

PATTERN = %r{(#|//|/\*|--)\s*(todo|fixme|warn)(\(.*\))?\b.*$}i.freeze

COMMENTS = ['#', '//', '/*', '--'].freeze

COLORS = {
  'todo' => :blue,
  'fixme' => :red,
  'warn' => :yellow
}.freeze

FILE_MAGIC = FileMagic.new(FileMagic::MAGIC_MIME)

# Checks if the provided file is a binary file.
def binary?(file)
  FILE_MAGIC.file(file) !~ %r{^text/}
end

# Recursively finds all files in the glob pattern and runs a block on each file.
def each_file(glob, &block)
  Dir[glob].reject { |e| File.directory?(e) || binary?(e) }.each(&block)
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
  in_todo_comment = false

  IO.foreach(file) do |line|
    if (type = line[PATTERN, 2])
      puts

      type.downcase!

      print_filename file, $INPUT_LINE_NUMBER
      print_comment line, type

      in_todo_comment = true

      previous_type = type
    elsif in_todo_comment && comment?(line)
      print_comment line, previous_type
    else
      in_todo_comment = false
    end

    previous_line = line
  end
end

puts

FILE_MAGIC.close
