module ApplicationHelper
  def apply_pagination_class_for_mobile
    'pagination-sm' if is_mobile_device?
  end
end
