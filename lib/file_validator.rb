# frozen_string_literal: true

require 'ruby-filemagic'

# Helper class for file type validation.
class FileValidator
  def self.start
    return unless block_given?

    validator = FileValidator.new
    yield(validator)
    validator.close
  end

  def initialize
    @file_magic = FileMagic.new(FileMagic::MAGIC_MIME)
  end

  # Checks if the provided file is a binary file based on the MIME type.
  def binary?(file)
    @file_magic.file(file) !~ %r{^text/}
  end

  # Disposes the FileMagic resource
  def close
    @file_magic.close
  end
end
