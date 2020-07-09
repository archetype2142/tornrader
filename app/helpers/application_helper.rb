module ApplicationHelper
  def class_for(flash_type)
    {
      success: 'is-info',
      registration_error: 'is-danger',
      error: 'is-danger',
      alert: 'is-danger',
      warning: 'is-warning',
      notice: 'is-info'
    }[flash_type.to_sym]
  end
  
  def flash_messages(opts = {})
    flashes = ''
    excluded_types = opts[:excluded_types].to_a.map(&:to_s)

    flash.to_h.except('order_completed').each do |msg_type, text|
      next if msg_type.blank? || excluded_types.include?(msg_type)

      flashes << content_tag(:div, class: "notification #{class_for(msg_type)}") do

        content_tag(:button, '&times;'.html_safe, class: 'delete', data: { dismiss: 'alert', hidden: true }) +
          content_tag(:span, text)
      end
    end
    flashes.html_safe
  end

  def display_price(amount)
    "$ #{number_with_delimiter(amount, delimiter: ',')}".html_safe
  end

  def display_line_price(line_item)
    qty = line_item.quantity
    itm_name = line_item&.items&.last&.name
    itm_price = display_price(line_item&.items&.last&.price)
    total_price = display_price(line_item.total)
    
    "#{itm_name}: #{itm_price} x #{qty} = #{total_price}".html_safe
  end
end
