class Order < ApplicationRecord
  # Quan hệ "người gán" (admin) và "người nhận" (shipper)
  belongs_to :assigned_shipper, class_name: "AdminUser", foreign_key: "assigned_to", optional: true
  belongs_to :assigned_admin,   class_name: "AdminUser", foreign_key: "assigned_by", optional: true

  # Trạng thái đơn
  enum :status, {
    pending: 0,      # mới tạo
    assigned: 1,     # đã phân cho shipper
    delivering: 2    # đang giao
  }


  # Validate
  validates :code, presence: true, uniqueness: true
  validates :customer_name, :customer_address, presence: true
  validates :customer_phone, presence: true,
                             format: { with: /\A[\d\s\+\-]{8,20}\z/, message: "sai định dạng" }
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  # === Lambda: các scope dùng lambda
  scope :high_value,   -> { where("total_amount >= ?", 500_000) }
  scope :unassigned,   -> { where(assigned_to: nil) }
  scope :of_shipper,   ->(uid) { where(assigned_to: uid) }

  # === Proc: bộ lọc tái sử dụng ở nhiều nơi
  FILTERS = {
    high_value: Proc.new { |o| o.total_amount >= 500_000 },
    pending:    Proc.new { |o| o.pending? },
  }

  # === Lambda: công thức phí ship (ví dụ)
  SHIPPING_FEE = ->(order) { order.total_amount >= 1_000_000 ? 0 : 30_000 }

  # Helper: tổng cuối cùng (ví dụ áp phí ship)
  def final_total
    total_amount + SHIPPING_FEE.call(self)
  end

  # === Block hook: cho phép tuỳ biến xử lý khi assign
  #   Order.assign_with(order, shipper) { |o, s| ... xử lý thêm ... }
  def self.assign_with(order, shipper)
    order.update!(assigned_to: shipper.id, status: :assigned)
    yield(order, shipper) if block_given? # block để tuỳ biến (log, notify...)
    order
  end
end
