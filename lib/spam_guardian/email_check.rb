module SpamGuardian
  EmailCheck = Struct.new(:email) do
    def valid?
      email.is_a?(String) && email.match?(/^[^@]+@[^@]+$/)
    end
  end
end