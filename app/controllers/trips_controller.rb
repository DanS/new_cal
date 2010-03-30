class TripsController < ApplicationController
  # GET /calendar
  # GET /trips.xml
  def calendar
    default_start = Date.today.strftime("%Y%m") + '01'
    @start_date = assign_from_param_session_or_default("start_date", default_start)
    @trips = Trip.filtered(params)
    @trips_by_date = Trip.by_date_string(params)
    @destination_list = Trip.list_destinations
    @destination_color_lookup = Hash[* Destination.all.map {|d| [d.place, d.letter]}.flatten]
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
    @communities = Community.all.collect {|c| c.name}
    @vehicles = Vehicle.all.collect {|v| v.name}
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
    @communities = Community.all.collect {|c| c.name}
    @vehicles = Vehicle.all.collect {|v| v.name}
  end

  # POST /trips
  # POST /trips.xml
  def create
    @trip = Trip.new(params[:trip])
    respond_to do |format|
      if @trip.save
        flash[:notice] = 'Trip was successfully created.'
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @trip, :status => :created, :location => @trip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
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
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
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
      format.xml  { head :ok }
    end
  end
end
