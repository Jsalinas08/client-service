class Clients::BuildService
  def initialize(client:, params:)
    @client = client
    @params = params.with_indifferent_access
  end

  def execute!
    build_client
  end

  private

  attr_reader :client, :params

  def build_client
    client.assign_attributes(params)
    client.save!
  end
end
