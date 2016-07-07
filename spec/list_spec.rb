require 'spec_helper'

describe "the format:list command" do
  let(:command_name) { "list" }

  let(:cog_env) do
    [
      {"foo" => "one"},
      {"lol" => "wut"},
      {"foo" => "two"},
      {"foo" => "three"}
    ]
  end

  before(:each) { ENV["COG_INVOCATION_STEP"] = "last" }

  it "generates a comma-delimited string with top-level fields in ascending order" do
    run_command(args: ["foo"])
    expect(command).to respond_with_text("one, three, two")
  end

  it "returns nothing if no items have the specified field (not empty string!)" do
    run_command(args: ["nobody_has_this"])
    expect(command).to respond_with(nil)
  end

  it "sorts in descending order if 'desc' sort order is specified" do
    run_command(args: ["foo"], options: {"order" => "desc"})
    expect(command).to respond_with_text("two, three, one")
  end

  it "sorts in ascending order if 'asc' sort order is specified" do
    run_command(args: ["foo"], options: {"order" => "asc"})
    expect(command).to respond_with_text("one, three, two")
  end

  it "fails if unrecognized sort order is specified" do
    expect {
      run_command(args: ["foo"], options: {"order" => "wat"})
    }.to raise_error(Cog::Error,
                     "Unrecognized sort order: use \"asc\" or \"desc\"")
  end

  it "joins with arbitrary string specified by 'join' option" do
    run_command(args: ["foo"], options: {"join" => "_"})
    expect(command).to respond_with_text("one_three_two")
  end

end
