class TripsController < ApplicationController
  # GET /calendar
  # GET /trips.xml
  @@first_day_of_current_week = Date.today - Date.today.wday.days

  def calendar
    default_start = @@first_day_of_current_week.strftime("%Y%m") + '01'
    @start_date = param_session_default("start_date", default_start)
    @cal_type = param_session_default("cal_type", 'month')
    filters = {
    :destination => param_session_default(:destination, nil),
    :start_date => param_session_default(:start_date, default_start)
    }
    @destination = filters[:destination] || "Everywhere"
    unless @cal_type == 'month'
      @start_date = start_date_for_week(@start_date)
      @end_date = param_session_default(:end_date, end_of_week(@start_date))
      filters[:end_date] = @end_date
      @trips_by_date = dates_between(@start_date, filters[:end_date]).merge Trip.by_date_string(filters)
    else
      filters[:end_date] =  plus_3_months(@start_date)
      @trips_by_date = Trip.by_date_string(filters)
    end
    @destination_list = to_destination_list(@trips_by_date)
  end

  # GET /trips/wip
  def wip
    default_start = @@first_day_of_current_week.strftime("%Y%m%d")
    @start_date = start_date_for_week(param_session_default("start_date", default_start))
    @end_date = (Date.parse(@start_date) + 6.days).strftime("%Y%m%d")
    @trips_by_hour = Trip.by_hour(@start_date, @end_date)
    @days = (0..6).collect { |i| Date.parse(@start_date) + i.days }
    @end_date = param_session_default(:end_date, end_of_week(@start_date))
    @vehicles = Vehicle.ordered.collect { |v| v.name }
  end

  # GET /trips/1
  # GET /trips/1.xml
  def show
    @trip = Trip.find(params[:id])
  end

  # GET /trips/new
  # GET /trips/new.xml
  def new
    @trip = Trip.new(:date => params[:date])
    @communities = Community.all.collect { |c| c.name }
    @vehicles = Vehicle.all.collect { |v| v.name }
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
    @communities = Community.all.collect { |c| c.name }
    @vehicles = Vehicle.all.collect { |v| v.name }
  end

  # POST /trips
  # POST /trips.xml
  def create
    @trip = Trip.new(params[:trip])
    respond_to do |format|
      if @trip.save
        flash[:notice] = 'Trip was successfully created.'
        format.html { redirect_to(root_path) }
        format.xml { render :xml => @trip, :status => :created, :location => @trip }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.xml
  def update
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        flash[:notice] = 'Trip was successfully updated.'
        format.html { redirect_to(root_path) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.xml
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml { head :ok }
    end
  end
end
