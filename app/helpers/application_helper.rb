module ApplicationHelper
  def current_full_url
    "#{request.base_url}#{request.original_fullpath}"
  end
end
