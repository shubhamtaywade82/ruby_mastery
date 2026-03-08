# frozen_string_literal: true
class ProcessOrderService
  def call(order)
    validate_order(order)
    charge_customer(order.user)
    send_email(order.user)
  end

  def validate_order(order)
    # ...
  end

  def charge_customer(user)
    PaymentGateway.charge(user)
  end

  def send_email(user)
    Mailer.send_receipt(user)
  end

  def calculate_tax(order)
    TaxCalculator.compute(order)
  end

  def update_inventory(order)
    Inventory.deduct(order)
  end
  
  def trigger_webhook
  end
  
  def create_audit_log
  end
  
  def notify_slack
  end
  
  def generate_invoice
  end
  
  def update_metrics
  end
  
  def sync_crm
  end
end
