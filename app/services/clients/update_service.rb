module Clients
  class UpdateService
    def initialize(id:, params:)
      @id = id
      @params = params.with_indifferent_access
    end

    def update
      update_client
    end

    private

    attr_reader :id, :params

    def update_client
      update = BuildService.new(client: client, params: params)
      update.execute!

      client
    end

    def client
      @client ||= Query.new.find(id)
    end
  end
end
