#!/usr/bin/env ruby

require 'cog/command'
require 'text-table'

class CogCmd::Format::Head < Cog::Command
  def run_command
    count = request.args[0].to_i
    pos = (step == :first) ? 1 : Cog::Services::Memory.get(memory_key).to_i + 1
    Cog::Services::Memory.replace(memory_key, pos)
    response.content = request.input if count == 0 || pos <= count
  end
end
