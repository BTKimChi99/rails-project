class Admin::OrdersController < ApplicationController
    layout "main"
  before_action :require_admin!
  before_action :set_order, only: [:show, :edit, :update, :destroy, :assign, :start_delivery, :mark_delivered, :cancel]

  def index
    @orders = Order.order(created_at: :desc)
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params.merge(status: :pending, assigned_by: current_admin_user.id))
    if @order.save
      redirect_to admin_orders_path, notice: "Tạo đơn thành công"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @order.update(order_params)
      redirect_to admin_orders_path, notice: "Cập nhật đơn thành công"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to admin_orders_path, notice: "Đã xóa đơn"
  end

  # === Phân đơn cho shipper (dùng Block hook)
  def assign
    shipper = AdminUser.find(params[:shipper_id])
    Order.assign_with(@order, shipper) do |o, s|
      # Block: xử lý tuỳ biến sau khi gán, ví dụ ghi log / gửi thông báo
      Rails.logger.info "Admin #{current_admin_user.id} gán đơn #{o.code} cho shipper #{s.id}"
    end
    redirect_to admin_orders_path, notice: "Đã gán đơn cho shipper"
  rescue => e
    redirect_to admin_orders_path, alert: "Gán đơn thất bại: #{e.message}"
  end

  def start_delivery
    @order.update!(status: :delivering)
    redirect_to admin_orders_path, notice: "Đã chuyển trạng thái: đang giao"
  end

  def mark_delivered
    @order.update!(status: :delivered)
    redirect_to admin_orders_path, notice: "Đã giao hàng"
  end

  def cancel
    @order.update!(status: :canceled)
    redirect_to admin_orders_path, notice: "Đã hủy đơn"
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:code, :customer_name, :customer_phone, :customer_address, :total_amount)
  end

  def require_admin!
    # ví dụ: role == 1 là admin
    redirect_to root_path, alert: "Không có quyền" unless current_admin_user&.role == 1
  end

  def show
    # @order đã được set bởi before_action
  end
end
