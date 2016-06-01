#!/usr/bin/env ruby

require 'cog/command'
require 'text-table'

class CogCmd::Format::List < Cog::Command
  input :accumulate

  def run_command
    return unless step == :last

    list = fetch_input.map { |obj| obj[request.args[0]] }.sort
    list = list.reverse if request.options['order'] == 'desc'
    delim = request.options['join'] || ', '

    response.template = 'preformatted'
    response['body'] = list.join(delim)
  end
end
