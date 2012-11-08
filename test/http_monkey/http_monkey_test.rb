require "test_helper"

describe HttpMonkey do

  subject { HttpMonkey }

  it "#at" do
    subject.at("http://google.com.br").must_be_instance_of(HttpMonkey::EntryPoint)
  end

  it "#configure" do
    flag = "out block"
    subject.configure do
      self.must_be_instance_of(HttpMonkey::Configuration)
      flag = "inside block"
    end
    flag.must_equal("inside block")
  end

  describe "#build" do
    it "wont be same client" do
      subject.build.wont_be_same_as(HttpMonkey.default_client)
    end
    it "always return response by default" do
      url = "http://fakeserver.com"
      stub_request(:get, url).to_return(:body => "abc")

      http_client = subject.build
      response = http_client.at(url).get
      response.wont_be_nil
      response.body.must_equal("abc")
    end
  end

end