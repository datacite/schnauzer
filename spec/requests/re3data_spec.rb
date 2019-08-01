require 'rails_helper'

describe "Re3data", type: :request, vcr: true do
  let(:headers) { {'ACCEPT'=>'application/vnd.api+json', 'CONTENT_TYPE'=>'application/vnd.api+json' } }

  describe 'GET /re3data' do
    context 'filter by subject' do
      it 'returns repositories' do
        get '/re3data?subject=34', nil, headers: headers

        expect(json['data'].size).to eq(25)
        expect(json.dig('meta', 'total')).to eq(440)

        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2013-02-25T09:39:15Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("4TU.Centre for Research Data")
        expect(response.dig('attributes', 'subjects').size).to eq(29)
        expect(response.dig('attributes', 'subjects').last).to eq("scheme"=>"DFG", "text"=>"45 Construction Engineering and Architecture")
        expect(last_response.status).to eq(200)
      end
    end

    context 'filter by query' do
      it 'returns repositories' do
        get '/re3data?subject=34&query=climate', nil, headers: headers

        expect(json['data'].size).to eq(25)
        expect(json.dig('meta', 'total')).to eq(151)

        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2016-02-10T11:34:04Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("ACTRIS Data Centre")
        expect(last_response.status).to eq(200)
      end
    end

    context 'filter open access' do
      it 'returns repositories' do
        get '/re3data?subject=34&query=climate&open=true', nil, headers: headers

        expect(json['data'].size).to eq(25)
        expect(json.dig('meta', 'total')).to eq(132)

        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2016-02-10T11:34:04Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("ACTRIS Data Centre")
        expect(response.dig('attributes', 'dataAccesses').first).to eq("restrictions"=>[], "type"=>"open")
        expect(last_response.status).to eq(200)
      end
    end

    context 'filter certified' do
      it 'returns repositories' do
        get '/re3data?subject=34&query=climate&certified=true', nil, headers: headers

        expect(json['data'].size).to eq(19)
        expect(json.dig('meta', 'total')).to eq(19)

        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2013-10-07T09:39:16Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("Alaska Satellite Facility SAR Data Center")
        expect(response.dig('attributes', 'certificates').first).to eq("text"=>"WDS")
        expect(last_response.status).to eq(200)
      end
    end

    context 'filter pid' do
      it 'returns repositories' do
        get '/re3data?subject=34&query=climate&pid=true', nil, headers: headers

        expect(json['data'].size).to eq(25)
        expect(json.dig('meta', 'total')).to eq(79)

        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2017-09-07T07:43:06Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("ADS")
        expect(response.dig('attributes', 'pidSystems').first).to eq("text"=>"DOI")
        expect(last_response.status).to eq(200)
      end
    end

    context 'filter disciplinary' do
      it 'returns repositories' do
        get '/re3data?subject=34&query=climate&disciplinary=true', nil, headers: headers

        expect(json['data'].size).to eq(25)
        expect(json.dig('meta', 'total')).to eq(142)

        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2016-02-10T11:34:04Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("ACTRIS Data Centre")
        expect(response.dig('attributes', 'pidSystems').first).to eq("text"=>"none")
        expect(last_response.status).to eq(200)
      end
    end

    context 'sort by created' do
      it 'returns repositories' do
        get '/re3data?sort=created', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2014-06-25T09:39:17Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("CancerData.org")
        expect(last_response.status).to eq(200)
      end
    end

    context 'sort by created desc' do
      it 'returns repositories' do
        get '/re3data?sort=-created', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2016-01-27T11:59:56Z")
        expect(last_response.status).to eq(200)
      end
    end

    context 'sort by name' do
      it 'returns repositories' do
        get '/re3data?sort=name', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2015-02-19T09:39:18Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("1000 Functional Connectomes Project")
        expect(last_response.status).to eq(200)
      end
    end

    context 'sort by name desc' do
      it 'returns repositories' do
        get '/re3data?sort=-name', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2015-04-07T09:39:18Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("ZVDD")
        expect(last_response.status).to eq(200)
      end
    end

    context 'sort default' do
      it 'returns repositories' do
        get '/re3data', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2015-02-19T09:39:18Z")
        expect(response.dig('attributes', 'repositoryName')).to eq("1000 Functional Connectomes Project")
        expect(last_response.status).to eq(200)
      end
    end

    context 'page[size]=2' do
      it 'returns repositories' do
        get '/re3data?page[size]=2', nil, headers: headers

        expect(json['data'].size).to eq(2)
        expect(last_response.status).to eq(200)
      end
    end

    context 'page[size]=20' do
      it 'returns repositories' do
        get '/re3data?page[size]=100', nil, headers: headers

        expect(json['data'].size).to eq(100)
        expect(last_response.status).to eq(200)
      end
    end

    context 'page[size]=2 and page[number]=2' do
      it 'returns repositories' do
        get '/re3data?page[size]=2&page[number]=2', nil, headers: headers

        expect(json['data'].size).to eq(2)
        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'GET /re3data/:id' do
    context 'when the record exists' do
      it 'returns the repository' do
        get "/re3data/10.17616/R33314", nil, headers

        expect(last_response.status).to eq(200)
        expect(json.dig('data', 'id')).to eq("10.17616/R33314")
        expect(json.dig('data', 'attributes', 'repositoryName')).to eq("UniProtKB/Swiss-Prot")
      end
    end

    context 'when the record does not exist' do
      it 'returns a not found message' do
        get "/re3data/xxx", nil, headers

        expect(last_response.status).to eq(404)
        expect(json["errors"].first).to eq("status"=>"404", "title"=>"The resource you are looking for doesn't exist.")
      end
    end
  end

  describe 'GET /re3data/suggest' do
    it 'returns terms' do
      get '/re3data/suggest?query=clim', nil, headers: headers

      expect(json).to eq(["chip", "coli", "claims", "claim"])
      expect(last_response.status).to eq(200)
    end
  end
end
