class Public::BootcampsController < Public::FrontController

  def index

    ## Figure out which schools to show based on parameters

    _bootcamps = ::Bootcamp.all

    # Search query
    if params.key? :q
      _bootcamps = _bootcamps.search(params[:q])
    end

    # Tech Focus
    if params.key? :focus
      _bootcamps = _bootcamps.by_focus(params[:focus])
    end

    # Price
    if params.key? :price
      if params[:price].include? "-"
        min = params[:price].split('-')[0]
        max = params[:price].split('-')[1]
        _bootcamps = _bootcamps.by_price_range(min, max)
      else
        _bootcamps = _bootcamps.by_price(params[:price])
      end
    end

    # Location
    if params.key? :location
      _bootcamps = _bootcamps.by_location(params[:location])
    end

    @bootcamps = _bootcamps.includes(:locations).load

    ## Pull default filter information

    @locations = ::BootcampLocation.select(:city, :state).map { |l| l.city + ", " + l.state }.uniq
    @focuses = ::Bootcamp.pluck(:focus).compact.uniq

  end

  def show
    @bootcamp = ::Bootcamp.includes(:locations).find_by_id(params[:bootcamp_id])
  end

  protected

    def current_bootcamp_admin_or_super_admin_only
      return not_found unless current_account
      not_found unless Bootcamp.find_by_id(params[:bootcamp_id]).admins.pluck(:id).include?(current_account.id)
    end
  
end
