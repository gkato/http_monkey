module HttpMonkey

  class Client

    def initialize
      @conf = Configuration.new
    end

    def initialize_copy(source)
      super
      @conf = @conf.clone
    end

    def at(url)
      HttpMonkey::EntryPoint.new(self, url)
    end

    def net_adapter
      @conf.net_adapter
    end

    def storage
      @conf.storage
    end

    def configure(&block)
      @conf.instance_eval(&block) if block_given?
      self
    end

    def http_request(method, request)
      env = Client::EnvironmentBuilder.new(self, method, request).to_env
      code, headers, body = @conf.middlewares.execute(Middlewares::HttpRequest, env)
      body.close if body.respond_to?(:close)  # close when is a Rack::BodyProxy
      response = Client::Response.new(code, headers, body)

      client = self
      @conf.behaviours.execute(response.code) do |behaviour|
        behaviour.call(client, request, response)
      end
    end

  end

end
