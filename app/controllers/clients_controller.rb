class ClientsController < ApplicationController
  # GET /clients
  def index
    render json: Clients::Query.new.all
  end

  # GET /clients/:id
  def show
    render json:  Clients::Query.new.find(params[:id])
  end

  # POST /clients
  def create
    service = Clients::CreationService.new(params: client_params)
    client = service.create

    render json: client, status: :created
  end

  # PATCH/PUT /clients/:id
  def update
    service = Clients::UpdateService.new(id: params[:id], params: client_params)
    client = service.update

    render json: client, status: :ok
  end

  private

  def client_params
    ClientPermittedParams.permitted_params(params).to_h
  end
end
