#!/usr/bin/env ruby

require 'cog/command'
require 'text-table'

class CogCmd::Format::Table < Cog::Command
  input :accumulate

  def run_command
    return unless step == :last

    table = Text::Table.new
    table.head = request.args

    fetch_input.each do |row|
      table.rows << request.args.map { |field| row[field] }
    end

    response.template = 'preformatted'
    response['body'] = table.to_s
  end
end
