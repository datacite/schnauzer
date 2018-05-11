require 'rails_helper'

describe "Repositories", type: :request, vcr: true do
  let(:headers) { {'ACCEPT'=>'application/vnd.api+json', 'CONTENT_TYPE'=>'application/vnd.api+json' } }

  describe 'GET /repositories' do
    context 'sort by created' do
      it 'returns repositories' do
        get '/repositories?sort=created', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2014-03-31T09:39:16Z")
        expect(response.dig('attributes', 'repository-name')).to eq("UniProtKB/Swiss-Prot")
        expect(last_response.status).to eq(200)
      end
    end

    context 'sort by created desc' do
      it 'returns repositories' do
        get '/repositories?sort=-created', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2016-01-27T11:59:56Z")
        expect(last_response.status).to eq(200)
      end
    end

    context 'sort by name' do
      it 'returns repositories' do
        get '/repositories?sort=name', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2013-08-07T09:39:16Z")
        expect(response.dig('attributes', 'repository-name')).to eq("'Health Monitoring' Research Data Centre at the Robert Koch Institute")
        expect(last_response.status).to eq(200)
      end
    end

    context 'sort by name desc' do
      it 'returns repositories' do
        get '/repositories?sort=-name', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2015-04-07T09:39:18Z")
        expect(response.dig('attributes', 'repository-name')).to eq("ZVDD")
        expect(last_response.status).to eq(200)
      end
    end

    context 'sort default' do
      it 'returns repositories' do
        get '/repositories', nil, headers: headers

        expect(json['data'].size).to eq(25)
        response = json['data'].first
        expect(response.dig('attributes', 'created')).to eq("2014-03-31T09:39:16Z")
        expect(response.dig('attributes', 'repository-name')).to eq("UniProtKB/Swiss-Prot")
        expect(last_response.status).to eq(200)
      end
    end

    context 'page[size]=2' do
      it 'returns repositories' do
        get '/repositories?page[size]=2', nil, headers: headers

        expect(json['data'].size).to eq(2)
        expect(last_response.status).to eq(200)
      end
    end

    context 'page[size]=20' do
      it 'returns repositories' do
        get '/repositories?page[size]=100', nil, headers: headers

        expect(json['data'].size).to eq(100)
        expect(last_response.status).to eq(200)
      end
    end

    context 'page[size]=2 and page[number]=2' do
      it 'returns repositories' do
        get '/repositories?page[size]=2&page[number]=2', nil, headers: headers

        expect(json['data'].size).to eq(2)
        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'GET /repositories/:id' do
    context 'when the record exists' do
      it 'returns the repository' do
        get "/repositories/100010677", nil, headers

        expect(last_response.status).to eq(200)
        expect(json.dig('data', 'id')).to eq("100010677")
        expect(json.dig('data', 'attributes', 'repository-name')).to eq("UniProtKB/Swiss-Prot")
      end
    end

    context 'when the record does not exist' do
      it 'returns a not found message' do
        get "/repositories/xxx", nil, headers

        expect(last_response.status).to eq(404)
        expect(json["errors"].first).to eq("status"=>"404", "title"=>"The resource you are looking for doesn't exist.")
      end
    end
  end
end
