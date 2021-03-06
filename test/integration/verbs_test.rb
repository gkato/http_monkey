require "test_helper"

describe "Integration Specs - Verbs" do

  def self.before_suite
    @@server = MinionServer.new(MirrorApp).start
  end

  def self.after_suite
    @@server.shutdown
  end

  it "#get - no parameter" do
    response = HttpMonkey.at("http://localhost:4000").get
    server_env = YAML.load(response.body)

    server_env["REQUEST_METHOD"].must_equal("GET")
    server_env["QUERY_STRING"].must_be_empty
  end
  it "#get - with parameters" do
    response = HttpMonkey.at("http://localhost:4000").get(:q => "query")
    server_env = YAML.load(response.body)

    server_env["REQUEST_METHOD"].must_equal("GET")
    server_env["QUERY_STRING"].must_equal("q=query")
  end

  it "#post" do
    response = HttpMonkey.at("http://localhost:4000").post(:var => "post_var")
    server_env = YAML.load(response.body)

    server_env["REQUEST_METHOD"].must_equal("POST")
    server_env["rack.input"].must_equal("var=post_var")
  end

  it "#put" do
    response = HttpMonkey.at("http://localhost:4000").put(:var => "put_var")
    server_env = YAML.load(response.body)

    server_env["REQUEST_METHOD"].must_equal("PUT")
    server_env["rack.input"].must_equal("var=put_var")
  end

  it "#delete" do
    response = HttpMonkey.at("http://localhost:4000").delete
    server_env = YAML.load(response.body)

    server_env["REQUEST_METHOD"].must_equal("DELETE")
  end

end
