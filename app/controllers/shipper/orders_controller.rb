class Shipper::OrdersController < ApplicationController
  before_action :require_shipper!
  before_action :set_order, only: [:show, :update]

  def index
    @orders = Order.of_shipper(current_admin_user.id).order(created_at: :desc)
  end

  def show; end

  # Shipper cập nhật trạng thái (delivering → delivered)
  def update
    case params[:event]
    when "start_delivery"
      @order.update!(status: :delivering)
      redirect_to shipper_orders_path, notice: "Bắt đầu giao đơn #{@order.code}"
    when "mark_delivered"
      @order.update!(status: :delivered)
      redirect_to shipper_orders_path, notice: "Đã giao đơn #{@order.code}"
    else
      redirect_to shipper_orders_path, alert: "Sự kiện không hợp lệ"
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
    unless @order.assigned_to == current_admin_user.id
      redirect_to shipper_orders_path, alert: "Bạn không có quyền với đơn này"
    end
  end

  def require_shipper!
    redirect_to root_path, alert: "Không có quyền" unless current_admin_user&.role != 1
  end
end
