module Clients
  class Query #DAO
    attr_reader :model

    def initialize(model: Client)
      @model = model
    end

    def object
      model.new
    end

    def find(id)
      model.find(id)
    end

    def where(params)
      model.where(params.symbolize_keys)
    end

    def all
      model.all
    end
  end
end