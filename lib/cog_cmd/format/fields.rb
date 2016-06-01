#!/usr/bin/env ruby

require 'cog/command'
require 'text-table'

class CogCmd::Format::Fields < Cog::Command
  def run_command
    response.template = 'fields'
    response['fields'] = request.input.keys.sort
  end
end
