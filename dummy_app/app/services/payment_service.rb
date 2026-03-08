# frozen_string_literal: true
class PaymentService
  def self.call(order)
    CheckoutService.call(order) # Circular dependency
  end
end
