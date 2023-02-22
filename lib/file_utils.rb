# frozen_string_literal: true

require_relative 'file_validator'

# Adds utils to the Dir class.
class Dir
  # Recursively finds all text files in the glob pattern and runs a block on each file.
  def self.each_text_file(glob, &block)
    FileValidator.start do |validator|
      Dir[glob].reject { |e| File.directory?(e) || validator.binary?(e) }.each(&block)
    end
  end
end
