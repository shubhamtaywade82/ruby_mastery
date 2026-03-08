# frozen_string_literal: true

require "rspec"
require_relative "../lib/ruby_mastery"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.disable_monkey_patching!
  config.formatter = :documentation
end
