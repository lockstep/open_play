module Admin
  class BusinessesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Business.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Business.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    def export_bookings
      @bookings = Booking.belongs_to_business(params[:id]).past_60_days
        .includes(:order, :user, :reservable)

      respond_to do |format|
        format.xls {
          response.headers['Content-Disposition'] =
            'attachment; filename="past-60-days-reservations.xls"'
        }
      end
    end

  end
end
