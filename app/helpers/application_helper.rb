module ApplicationHelper
	def pagination_class
		'pagination-sm' if is_mobile_device?
	end

	def share_snippet
		"<div class='fb-send' data-href='#{Settings.app.share.url}' data-ref='share_direct'></div>".html_safe
	end

  def phone_number_link(text)
    sets_of_numbers = text.scan(/[0-9]+/)
    number = "#{sets_of_numbers.join('-')}"
    link_to text, "tel:#{number}"
  end

end
