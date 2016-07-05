require 'spec_helper'

describe "the format:head command" do
  let(:command_name) { "head" }

  let(:cog_env) do
    {"a" => 1}
  end

  # The head command relies on the history of calls that went before
  # in order to build up its internal counter
  def set_last_position(pos)
    ENV["COG_INVOCATION_STEP"] = (pos+1).to_s
    expect(Cog::Services::Memory).to receive(:get).with(invocation_id).and_return(pos)
  end

  context "testing a typical series of invocations" do
    (1..6).each do |current_position|
      threshold = 3
      if current_position <= threshold
        it "passes item #{current_position} with a threshold of #{threshold}" do
          set_last_position(current_position-1)
          run_command(args: [threshold])
          expect(command).to respond_with(cog_env)
        end
      else
        it "does not pass item #{current_position} with a threshold of #{threshold}" do
          set_last_position(current_position-1)
          run_command(args: [threshold])
          expect(command).to respond_with(nil)
        end
      end
    end
  end

  context "testing the default threshold" do
    default = 10
    (1..(default + 1)).each do |current_position|
      if current_position <= default
        it "passes item #{current_position} with an unspecified threshold (defaults to #{default})" do
          set_last_position(current_position-1)
          run_command
          expect(command).to respond_with(cog_env)
        end
      else
        it "does not pass item #{current_position} with an unspecified threshold (defaults to #{default})" do
          set_last_position(current_position-1)
          run_command
          expect(command).to respond_with(nil)
        end
      end
    end
  end

  context "error cases" do

    it "string thresholds are not allowed" do
      expect {run_command(args: ["cog"])}.to raise_error(Cog::Error, "Must supply non-zero positive integer argument")
    end

    it "float thresholds are not allowed" do
      expect {run_command(args: [1.5])}.to raise_error(Cog::Error, "Must supply non-zero positive integer argument")
    end

    it "a threshold of zero is not allowed" do
      expect {run_command(args: [0])}.to raise_error(Cog::Error, "Must supply non-zero positive integer argument")
    end

    it "negative thresholds are not allowed" do
      expect {run_command(args: [-1])}.to raise_error(Cog::Error, "Must supply non-zero positive integer argument")
    end

  end
end
