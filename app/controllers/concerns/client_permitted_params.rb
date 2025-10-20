class ClientPermittedParams
  CLIENT_PERMITTED = %i[name dni email address]

  def self.permitted_params(params)
    params.permit(CLIENT_PERMITTED)
  end
end
