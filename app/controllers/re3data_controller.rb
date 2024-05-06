class Re3dataController < ApplicationController
  before_action :set_repository, only: [:show, :badge]

  def index
    sort = case params[:sort]
           when "relevance" then { _score: { order: 'desc' }}
           when "name" then { "repositoryName.sortable" => { order: 'asc' }}
           when "-name" then { "repositoryName.sortable" => { order: 'desc' }}
           when "created" then { created: { order: 'asc' }}
           when "-created" then { created: { order: 'desc' }}
           else { "repositoryName.sortable" => { order: 'asc' }}
           end

    page = params[:page] || {}
    if page[:size].present?
      page[:size] = [page[:size].to_i, 1000].min
      max_number = page[:size] > 0 ? 10000/page[:size] : 1
    else
      page[:size] = 25
      max_number = 10000/page[:size]
    end
    page[:number] = page[:number].to_i > 0 ? [page[:number].to_i, max_number].min : 1

    if params[:id].present?
      response = Repository.find_by_id(params[:id])
    elsif params[:ids].present?
      response = Repository.find_by_id(params[:ids], page: page, sort: sort)
    else
      response = Repository.query(params[:query],
        page: page,
        sort: sort,
        subject: params[:subject],
        open: params[:open],
        certified: params[:certified],
        pid: params[:pid],
        software: params[:software],
        disciplinary: params[:disciplinary])
    end

    total = response.total
    total_pages = page[:size] > 0 ? (total.to_f / page[:size]).ceil : 0

    @repositories = response.results

    options = {}
    options[:meta] = {
      total: total,
      "totalPages" => total_pages,
      page: page[:number]
    }.compact

    options[:links] = {
      self: request.original_url,
      next: @repositories.blank? ? nil : request.base_url + "/repositories?" + {
        query: params[:query],
        "page[number]" => page[:number] + 1,
        "page[size]" => page[:size],
        sort: params[:sort] }.compact.to_query
      }.compact
    options[:is_collection] = true

    render json: Re3dataSerializer.new(@repositories, options).serializable_hash.to_json, status: :ok
  rescue Elasticsearch::Transport::Transport::Errors::LengthRequired
    render json: []
  end

  def show
    options = {}
    options[:is_collection] = false

    render json: Re3dataSerializer.new(@repository, options).serializable_hash.to_json, status: :ok
  end

  def suggest
    response = Repository.suggest(params[:query])

    render json: response.dig("suggest", "phrase_prefix", 0, "options").map { |s| s["text"] }.to_json
  end

  def badge
    url= "http://www.re3data.org/public/badges/s/light/#{@repository.identifier["re3data"]}"
    result = Maremma.get(url, accept: "image/svg+xml", raw: true)

    render body: result.body.fetch("data", nil), content_type: "image/svg+xml"
  end

  protected

  def set_repository
    @repository = Repository.find_by_id(params[:id]).first
    fail Elasticsearch::Transport::Transport::Errors::NotFound unless @repository.present?
  end
end
