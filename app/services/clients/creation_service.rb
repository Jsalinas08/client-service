module Clients
  class CreationService

    def initialize(params:)
      @params = params.with_indifferent_access
    end

    def create
      create_client
    end

    private

    attr_reader :params

    def create_client
      BuildService.new(client: client, params: params).execute!

      client
    end

    def client
      @client ||= Query.new.object
    end
  end
end
