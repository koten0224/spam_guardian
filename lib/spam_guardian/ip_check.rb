module SpamGuardian
  IpCheck = Struct.new(:ip) do
    def valid?
      return false unless ip.is_a?(String)
       context.ipv4? || context.ipv6?
    rescue IPAddr::InvalidAddressError => ex
      false
    end

    def context
      @context ||= IPAddr.new(ip)
    end
  end
end