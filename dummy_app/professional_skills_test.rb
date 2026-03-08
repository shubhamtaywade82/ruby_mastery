# frozen_string_literal: true

# 1. Clean Code: Vague names and Else
def process(data)
  if data.nil?
    return false
  else
    # Vague name 'item'
    item = data.first
    puts item
  end
end

# 2. SOLID: Dependency Inversion Violation (Hardcoded new)
class OrderProcessor
  def run
    # Hardcoded logger
    logger = Logger.new
    logger.log("Processing...")
  end
end

# 3. Ruby Modernization: Data.define suggestion
Point = Struct.new(:x, :y)

# 4. Design Pattern: Strategy suggestion
def execute_command(cmd)
  case cmd
  when 'start' then puts 'Starting'
  when 'stop' then puts 'Stopping'
  when 'pause' then puts 'Pausing'
  when 'resume' then puts 'Resuming'
  when 'restart' then puts 'Restarting'
  end
end

# 5. Design Pattern: Decorator/Presenter suggestion
class Order < ApplicationRecord
  def display_price; end
  def display_status; end
  def format_date; end
  def format_address; end
  def format_items; end
end
