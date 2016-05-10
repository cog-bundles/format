#!/usr/bin/env ruby

Dir.chdir(File.dirname(__FILE__))

require 'bundler/setup'
require 'json'
require 'net/http'
require 'text-table'

def default_key
  ENV['COG_INVOCATION_ID']
end

def headers
  {
    "Authorization" => "pipeline #{ENV['COG_SERVICE_TOKEN']}",
    "Content-Type"  => "application/json"
  }
end

def uri_for(key)
  URI(ENV['COG_SERVICES_ROOT'] + "/v1/services/memory/1.0.0/#{key}")
end

def get(key)
  uri = uri_for(key)
  res = Net::HTTP.start(uri.host, uri.port) do |http|
    req = Net::HTTP::Get.new(uri)
    headers.each { |k,v| req[k] = v }
    http.request(req)
  end

  JSON.parse(res.body)
end

def accum(key, value)
  data = {
    "op" => "accum",
    "value" => value
  }

  uri = uri_for(key)
  req = Net::HTTP::Post.new(uri, headers)
  req.body = data.to_json

  res = Net::HTTP.start(uri.host, uri.port) do |http|
    http.request(req)
  end
end

def fields
  (0 .. (ENV['COG_ARGC'].to_i - 1)).map { |n| ENV["COG_ARGV_#{n}"] }
end

def cog_input_data
  data = JSON.parse(STDIN.read)
  Hash[fields.map { |k| [k, data[k]] }]
end

case ENV['COG_INVOCATION_STEP']
when "last"
  data = get(default_key) << cog_input_data

  table = Text::Table.new
  table.head = fields

  data.each do |row|
    table.rows << fields.map { |f| row[f] }
  end

  puts "```" + table.to_s + "```"
else
  accum(default_key, cog_input_data)
end
