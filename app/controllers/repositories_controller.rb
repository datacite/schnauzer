class RepositoriesController < ApplicationController
  def index
    page = (params.dig(:page, :number) || 1).to_i
    size = (params.dig(:page, :size) || 25).to_i
    from = (page - 1) * size

    sort = case params[:sort]
           when "name" then { "repositoryName" => { order: 'asc' }}
           when "-name" then { "repositoryName" => { order: 'desc' }}
           when "created" then { created: { order: 'asc' }}
           when "-created" then { created: { order: 'desc' }}
           else { _score: { order: 'desc' } }
           end

    if params[:id].present?
      response = Repository.find_by_id(params[:id])
    elsif params[:ids].present?
      response = Repository.find_by_ids(params[:ids], from: from, size: size, sort: sort)
    else
      params[:query] ||= "*"
      response = Repository.query(params[:query], from: from, size: size, sort: sort, subjects: params[:subjects])
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
  end

  def show
    @repository = Repository.find_by_id(params[:id]).first
    fail Elasticsearch::Transport::Transport::Errors::NotFound unless @repository.present?

    render jsonapi: @repository
  end
end
