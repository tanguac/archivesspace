require 'spec_helper'

describe 'Location controller' do

  it "can update a location" do
    loc = create(:json_location)
    loc.room = "2-26"
    loc.save

    expect(JSONModel(:location).find(loc.id).room).to eq("2-26")

  end


  it "can give a list of locations" do
    create(:json_location)
    expect(JSONModel(:location).all(:page => 1)['results'].count).to eq(1)
  end


  it "can perform a dry run batch creation of locations" do
    batch = JSONModel(:location_batch).from_hash(build(:json_location).to_hash.merge({
                                                   "coordinate_1_range" => {
                                                     "label" => "Range",
                                                     "start" => "1",
                                                     "end" => "10"
                                                   },
                                                   "coordinate_2_range" => {
                                                     "label" => "Section",
                                                     "start" => "A",
                                                     "end" => "M"
                                                   },
                                                   "coordinate_3_range" => {
                                                     "label" => "Shelf",
                                                     "start" => "1",
                                                     "end" => "7"
                                                   }
                                                 }))


    response = JSONModel::HTTP.post_json(URI("#{JSONModel::HTTP.backend_url}/locations/batch?dry_run=true"),
                              batch.to_json)

    batch_response = ASUtils.json_parse(response.body)

    expect(batch_response.length).to eq(910)
    expect(batch_response[0]["uri"]).to be_nil
  end


  it "can perform a batch creation of locations" do
    batch = JSONModel(:location_batch).from_hash(build(:json_location).to_hash.merge({
                                                   "coordinate_1_range" => {
                                                     "label" => "Range",
                                                     "start" => "1",
                                                     "end" => "10"
                                                   },
                                                   "coordinate_2_range" => {
                                                     "label" => "Section",
                                                     "start" => "A",
                                                     "end" => "M"
                                                   },
                                                   "coordinate_3_range" => {
                                                     "label" => "Shelf",
                                                     "start" => "1",
                                                     "end" => "7"
                                                   }
                                                 }))


    response = JSONModel::HTTP.post_json(URI("#{JSONModel::HTTP.backend_url}/locations/batch"),
                                         batch.to_json)

    batch_response = ASUtils.json_parse(response.body)

    expect(batch_response.length).to eq(910)
    expect(JSONModel.parse_reference(batch_response[0])[:type]).to eq("location")
  end


  it "shows all locations from all repositories" do
    create(:json_location)
    expect(JSONModel(:location).all(:page => 1)['results'].count).to eq(1)

    make_test_repo('Next1');
    expect(JSONModel(:location).all(:page => 1)['results'].count).to eq(1)
    create(:json_location)
    create(:json_location)

    make_test_repo('Next2')
    create(:json_location)
    expect(JSONModel(:location).all(:page => 1)['results'].count).to eq(4)
  end

 it "can update locations in batches" do
    make_test_repo('Batch Edit')
    locations = []
    3.times do
      location =  create(:json_location)
      locations << location[:uri]
    end

    batch = JSONModel(:location_batch_update).from_hash(build(:json_location).to_hash.merge({
                                                   "record_uris"  => locations,
                                                   "building" => "Batch Edited",
                                                   "floor" => "13th"
                                                 }))
    JSONModel::HTTP.post_json(URI("#{JSONModel::HTTP.backend_url}/locations/batch_update"),
                                         batch.to_json)
    Location.all.each do |location|
      expect(location[:building]).to eq("Batch Edited")
      expect(location[:floor]).to eq("13th")
    end
 end

end
