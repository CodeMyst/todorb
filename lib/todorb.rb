#!/usr/bin/env ruby

# frozen_string_literal: true

require 'English'
require_relative 'file_utils'
require_relative 'todo_checker'

def main
  Dir.each_text_file('./**/*') { |file| TodoChecker.new.check_file file }

  puts
end

main
