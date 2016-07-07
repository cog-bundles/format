#!/usr/bin/env ruby

require 'cog/command'

class CogCmd::Format::Head < Cog::Command

  DEFAULT_THRESHOLD = 10

  def run_command
    threshold = get_threshold
    pos = (step == :first) ? 1 : Cog::Services::Memory.get(memory_key).to_i + 1
    Cog::Services::Memory.replace(memory_key, pos)
    response.content = request.input if pos <= threshold
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
