module RequestUrlHelper
  def current_full_url
    "#{request.base_url}#{request.original_fullpath}"
  end

  def business_full_url(order)
    "#{request.base_url}#{business_path(order.activity_business_id)}"
  end
end
