#!/usr/bin/env ruby

require 'cog/command'

class CogCmd::Format::Fields < Cog::Command

  def run_command
    fields = request.input.keys
    if !fields.empty?
      response.template  = 'fields'
      response['fields'] = fields.sort
    end
  end

end
