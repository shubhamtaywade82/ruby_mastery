# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/ruby_mastery/analyzers/rails_domain_analyzer"
require_relative "../../lib/ruby_mastery/analyzers/service_object_analyzer"
require_relative "../../lib/ruby_mastery/analyzers/rails_controller_query_analyzer"

RSpec.describe "Rails Domain Analyzers" do
  def parse_ast(code, file = "test.rb")
    buffer = Parser::Source::Buffer.new(file)
    buffer.source = code
    Parser::CurrentRuby.new.parse(buffer)
  end

  describe RubyMastery::Analyzers::RailsDomainAnalyzer do
    it "detects anemic model" do
      code = <<~RUBY
        class Order < ApplicationRecord
        end
      RUBY
      ast = parse_ast(code)
      violations = described_class.new("app/models/order.rb", ast).analyze
      expect(violations.any? { |v| v.message == "Anemic domain model" }).to be true
    end

    it "detects callback abuse" do
      code = <<~RUBY
        class User < ApplicationRecord
          before_save :do_1
          after_save :do_2
          before_create :do_3
          after_create :do_4
          after_commit :do_5
        end
      RUBY
      ast = parse_ast(code)
      violations = described_class.new("app/models/user.rb", ast).analyze
      expect(violations.any? { |v| v.message == "Callback abuse detected" }).to be true
    end
  end

  describe RubyMastery::Analyzers::ServiceObjectAnalyzer do
    it "detects service object with .call" do
      code = <<~RUBY
        class ProcessOrderService
          def self.call(order)
          end
        end
      RUBY
      ast = parse_ast(code)
      violations = described_class.new("app/services/process_order_service.rb", ast).analyze
      expect(violations.any? { |v| v.message == "Service object may contain domain logic" }).to be true
    end
  end

  describe RubyMastery::Analyzers::ControllerQueryAnalyzer do
    it "detects query leakage in controllers" do
      code = <<~RUBY
        class OrdersController < ApplicationController
          def index
            @orders = Order.where(status: 'pending')
          end
        end
      RUBY
      ast = parse_ast(code)
      violations = described_class.new("app/controllers/orders_controller.rb", ast).analyze
      expect(violations.any? { |v| v.message == "Query logic inside controller" }).to be true
    end
  end
end
