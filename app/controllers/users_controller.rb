class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      bypass_sign_in(@user)
      redirect_to user_path(@user), notice: 'Successfully updated user profile'
    else
      render 'edit'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    permitted_params = %i[first_name last_name phone_number password
                          password_confirmation address latitude longitude]
    params.require(:user).permit(permitted_params)
  end
end
