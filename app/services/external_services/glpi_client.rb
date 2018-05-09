class GLPIClient
  HOST_URL = 'www.glpi.com'

  def get_computer(args = {})
    uri = URI::HTTP.build(
        host: HOST_URL,
        query: {
            apikey: ENV.fetch('GLPI_API_KEY')
        }.merge(args).to_query
    )
    HTTParty.get(uri)
  end
end
