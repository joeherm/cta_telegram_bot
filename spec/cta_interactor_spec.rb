require_relative '../lib/cta_interactor'

describe ::CTAInteractor do

  let(:mock_stops) {
    [{:stop_id=>"30162",:lon=>"-87.669147", :lat=>"41.857908"},
    {:stop_id=>"30152",:lon=>"-87.714842", :lat=>"41.853839"}]
  }

  let(:mock_times) {
    {"ctatt" =>
      {
        "eta" => [{"stpDe"=>"Service toward Howard", "arrT" => "20160629 17:26:37"}]
      }
    }
  }

  let(:mock_cta_wrapper) { instance_double('::CTAWrapper', stops: mock_stops, arrivals: mock_times) }
  
  subject { described_class.new(mock_cta_wrapper) }
  describe '#get_closest_stop' do
    it 'given 41.9, 81.7 returns sheridan' do
      stop = subject.get_closest_stop(41.853839, -87.714842)
      expect(stop[:stop_id]).to eq("30152")
    end
  end

  describe '#get_times_for_station' do
    it 'returns array of formatted station times' do
      expect(subject.get_times_for_station(1)).to eq(["Service toward Howard coming at  5:26 PM"])
    end
  end
end