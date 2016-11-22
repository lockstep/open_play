module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?
    messages = resource.errors.full_messages.map {|msg| content_tag(:div, msg)}.join

    html = <<-HTML
    <div class='row'>
      <div class='col-xs-4 offset-xs-4'>
        <div id="error_explanation" class="alert alert-danger" role="alert">
          #{messages}
        </div>
      </div>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end
