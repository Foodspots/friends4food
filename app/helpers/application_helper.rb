module ApplicationHelper
  def pagination_class
    'pagination-sm' if is_mobile_device?
  end
end
