module ServeursHelper
  def calculate_ports_sums(baie, servers)
    # sums per baie and per type of port
    sums = { baie.id => {'XRJ' => 0,'RJ' => 0,'FC' => 0,'IPMI' => 0} }
    servers.each do |server|
      server.ports_per_type.each do |type, sum|
        sums[baie.id][type] = sums[baie.id][type].to_i + sum
      end
    end
    sums
  end
end
