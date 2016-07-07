require "spec_helper"

describe "the format:fields command" do
  let(:command_name) { "fields" }

  let(:cog_env) do
    {"foo" => 1,
     "bar" => 2,
     "baz" => {"inner" => 3}}
  end

  it "returns the top-level fields in a sorted array" do
    run_command
    expect(command).to respond_with({"fields" => ["bar", "baz", "foo"]})
  end

  context "with no input (i.e., at beginning of a pipeline)" do
    let(:cog_env) { {} }

    it "returns nothing" do
      run_command
      expect(command).to respond_with(nil)
    end
  end

end
