class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
     unless current_admin_user&.role == 1
        render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
     end
  end
end
