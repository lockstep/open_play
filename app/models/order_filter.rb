class OrderFilter
  include ActiveModel::Model

  attr_accessor :from_date, :to_date, :activity_type

  def initialize(params)
    params = {} if params.nil?

    if params[:from_date].blank?
      params[:from_date] = Date.current.strftime('%d %b %Y')
    end

    if params[:to_date].blank?
      params[:to_date] = Date.current.strftime('%d %b %Y')
    end

    super(params)
  end
end
