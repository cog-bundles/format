require 'spec_helper'

describe "The format:pluck command" do
  let(:command_name) { "pluck" }

  context "on the final invocation" do
    before(:each) { ENV["COG_INVOCATION_STEP"] = "last" }

    let(:cog_env) do
      [
        {
          "one" => [{ "name" => "one_0" }, { "name" => "one_1" }],
          "two" => [{ "name" => "two_0" }, { "name" => "two_1" }]
        },
        { "three" => "number3" },
        { "four" => "number4" },
        { "five" => { "name" => "Number5", "status" => "Is Alive" }}
      ]
    end

    it "returns a single matching string as body" do
      run_command(args: ["three"])
      expect(command).to respond_with({ "body" => "number3" })
    end

    it "returns a single matching string as a named field" do
      run_command(args: ["four"], options: { "as": "myfield" })
      expect(command).to respond_with({ "myfield" => "number4" })
    end

    it "returns a single matching object as body" do
      run_command(args: ["five"])
      expect(command).to respond_with({ "name" => "Number5", "status" => "Is Alive" })
    end

    it "returns a single matching object as a named field" do
      run_command(args: ["five"], options: { "as": "johnny" })
      expect(command).to respond_with({"johnny" => { "name" => "Number5", "status" => "Is Alive" }})
    end

    it "returns an array of matching objects" do
      run_command(args: ["one"])
      expect(command).to respond_with([{ "name" => "one_0" }, { "name" => "one_1" }])
    end

    it "returns an array of matching objects as a named field" do
      run_command(args: ["one"], options: { "as" => "uno" })
      expect(command).to respond_with({ "uno" => [{ "name" => "one_0" }, { "name" => "one_1" }]})
    end
  end
end
