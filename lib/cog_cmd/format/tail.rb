#!/usr/bin/env ruby

require 'cog/command'

class CogCmd::Format::Tail < Cog::Command

  DEFAULT_THRESHOLD = 10

  input :accumulate

  def run_command
    return unless step == :last
    threshold = get_threshold
    response.content = fetch_input.last(threshold)
  end

  private

  def get_threshold
    raw = request.args[0]
    if raw.nil?
      DEFAULT_THRESHOLD
    else
      num = Integer(raw)
      raise unless num > 0
      num
    end
  rescue
    fail("Must supply non-zero positive integer argument")
  end

end
