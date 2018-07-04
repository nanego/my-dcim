# configures public url for our application
OmniAuth.config.full_host = Proc.new do |env|
  url = env["rack.session"]["omniauth.origin"] || env["omniauth.origin"]
  #if no url found, fall back to config secrets
  if url.blank?
    url = "http://#{Rails.application.secrets.domain_name}"
  else #else, parse it and remove both request_uri and query_string
    uri = URI.parse(url)
    url = "#{uri.scheme}://#{uri.host}"
    url << ":#{uri.port}" unless uri.default_port == uri.port
  end
  url
end
