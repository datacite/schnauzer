class RepositoriesController < ApplicationController
  def index
    page = (params.dig(:page, :number) || 1).to_i
    size = (params.dig(:page, :size) || 25).to_i
    from = (page - 1) * size

    sort = case params[:sort]
           when "relevance" then { _score: { order: 'desc' }}
           when "name" then { "repositoryName.sortable" => { order: 'asc' }}
           when "-name" then { "repositoryName.sortable" => { order: 'desc' }}
           when "created" then { created: { order: 'asc' }}
           when "-created" then { created: { order: 'desc' }}
           else { "repositoryName.sortable" => { order: 'asc' }}
           end

    if params[:id].present?
      response = Repository.find_by_id(params[:id])
    elsif params[:ids].present?
      response = Repository.find_by_ids(params[:ids], from: from, size: size, sort: sort)
    else
      response = Repository.query(params[:query], 
        from: from, 
        size: size, 
        sort: sort, 
        subject: params[:subject],
        open: params[:open], 
        certified: params[:certified],
        pid: params[:pid],
        disciplinary: params[:disciplinary])
    end

    total = response.total
    total_pages = (total.to_f / size).ceil

    @repositories = Kaminari.paginate_array(response.results, total_count: total).page(page).per(size)

    meta = {
      total: total,
      total_pages: total_pages,
      page: page
    }.compact

    render jsonapi: @repositories, meta: meta
  rescue Elasticsearch::Transport::Transport::Errors::LengthRequired
    render json: []
  end

  def show
    @repository = Repository.find_by_id(params[:id]).first
    fail Elasticsearch::Transport::Transport::Errors::NotFound unless @repository.present?

    render jsonapi: @repository
  end

  def suggest
    response = Repository.suggest(params[:query])

    render json: response.dig("suggest", "phrase_prefix", 0, "options").map { |s| s["text"] }.to_json
  end

  def badge
    id = "http://www.re3data.org/public/badges/s/light/" + params[:id]
    result = Maremma.get(id, accept: "image/svg+xml", raw: true)
    render body: result.body.fetch("data", nil), content_type: "image/svg+xml"
  end
end
