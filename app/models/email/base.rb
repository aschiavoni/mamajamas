module Email
  class Base
    protected

    def self.api
      @@api ||= Gibbon::API.new
    end

    def api
      @api ||= self.class.api
    end
  end
end
