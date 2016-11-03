#!/usr/bin/env ruby

require 'cog/command'
require 'jsonpath'

class CogCmd::Format::Pluck < Cog::Command
  input :accumulate

  def run_command
    return unless step == :last

    fail("format:pluck requires a path") if request.args[0] == nil

    path = JsonPath.new("$.#{request.args[0]}")
    content = fetch_input.map { |input| path.on(input) }.flatten
    content = content.first if content.size == 1

    response.content = build_reply(content)
  end

  def build_reply(content)
    target = request.options['as']

    if valid_cog_response?(content)
      target.nil? ? content : { target => content}
    else
      { (target || 'body') => content }
    end
  end

  def valid_cog_response?(content)
    content.is_a?(Hash) ||
    (content.is_a?(Array) && !content.map { |i| i.is_a?(Hash) }.include?(false))
  end
end
