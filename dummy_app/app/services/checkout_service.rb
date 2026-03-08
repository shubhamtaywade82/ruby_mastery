# frozen_string_literal: true
class CheckoutService
  def self.call(order)
    Order.find(order.id)
    PaymentService.call(order)
    InventoryService.call(order)
    ShippingService.call(order)
    NotificationService.call(order)
  end
end
