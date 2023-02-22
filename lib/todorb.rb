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

require 'English'
require_relative 'file_utils'
require_relative 'todo_checker'

def main
  Dir.each_text_file('./**/*') { |file| TodoChecker.new.check_file file }

  puts
end

main
