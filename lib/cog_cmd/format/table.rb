#!/usr/bin/env ruby

require 'cog/command'
require 'text-table'
require 'jsonpath'

class CogCmd::Format::Table < Cog::Command
  # Since cog commands that are run in a pipeline are run once for each JSON object
  # in their input, if we want to build an aggregate view of those objects we need
  # to record them so that we can process them all at the end. The cog-rb library
  # has built-in support that uses the memory service to help with that.
  #
  # If you don't need to accumulate input, you can exclude the following line from
  # your script:
  input :accumulate

  # cog-rb expects to find a method called `run_command` in the class for your
  # command.
  def run_command
    # This is more support for accumulating input and working on it all at once.
    # Cog tells commands that are run as a step in a pipeline whether they're the
    # first or last invocation for that step. In our case, we don't want to do
    # anything or return any results until we've accumulated all of the input so
    # we return immediately until we reach that step.
    return unless step == :last

    table = Text::Table.new
    mappings   = mappings(request.args)
    table.head = mappings.map{|m| m[:name]}

    fetch_input.each do |input|
      table.rows << mappings.map{|m| m[:path].on(input).first || ""}
    end

    # Set the template that we'd like to use for the output and assign the
    # appropriate values to the matching keys in the response object. cog-rb
    # handles the rest.
    response.template = 'preformatted'
    response['body'] = table.to_s
  end

  def mappings(args)
    args_with_aliases = args.map{|a| with_alias(a)}
    aliases = args_with_aliases.map(&:first)
    conflicting_aliases = aliases.select{|a| aliases.count(a) > 1}.uniq
    args_with_aliases.map do |a, selector|
      name = conflicting_aliases.include?(a) ? selector : a
      {name: name, path: JsonPath.new("$.#{selector}")}
    end
  end

  # Generate an alias/selector pair
  def with_alias(arg)
    if arg.include?("=")
      arg.split("=", 2)
    elsif arg.include?(".")
      [arg.split(".").last, arg]
    else
      [arg, arg]
    end
  end

end
