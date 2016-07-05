#!/usr/bin/env ruby

require 'cog/command'

class CogCmd::Format::List < Cog::Command
  input :accumulate

  def run_command
    return unless step == :last
    field = request.args[0]
    order = get_sort_order

    list = fetch_input.map { |obj| obj[field] }.compact.sort

    if !list.empty?
      list = list.reverse if order == 'desc'
      delim = request.options['join'] || ', '

      response.template = 'preformatted'
      response['body'] = list.join(delim)
    end
  end

  private

  def get_sort_order
    order = request.options["order"]
    case order
    when nil
      "asc"
    when "asc", "desc"
      order
    else
      fail("Unrecognized sort order: use \"asc\" or \"desc\"")
    end
  end

end
