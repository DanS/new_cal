shared_examples_for "a template that renders the trip_form partial" do
  it "renders the trips/trip_form partial" do
    template.should_receive(:render).with(
      :partial => 'trip_form',
      :locals => {:trip => assigns[:trip]}
    )
    render
  end
end