class WelcomeController < ApplicationController
  layout 'public'

  def index
    if current_user&.should_reset_session_location?
      current_user.update_session_location # Set session location to nil
    end
  end
end
