require "./agent"
require "./tools/*"
require "log"
require "tourmaline"
require "validator/is"

module Pingasius
  VERSION = "0.1.1"
  Log     = ::Log.for("main")

  class Daemon
    options = Options.new
    Log.info { "Pingasius version #{VERSION} started" }
    Log.level = :debug if options.settings.debug?
    Log.debug { "using #{ENV["BOT_TOKEN"]} token" }

    client = Tourmaline::Client.new(ENV["BOT_TOKEN"])
    agent = Pingasius::Agent.new(options)

    echo_handler = Tourmaline::CommandHandler.new("help") do |ctx|
      ctx.reply(agent.commands_available)
    end

    ping_handler = Tourmaline::CommandHandler.new("ping") do |ctx|
      text = ctx.text.to_s
      to_reply = agent.do_ping(text)
      ctx.reply(to_reply) unless to_reply.nil?
    end

    host_handler = Tourmaline::CommandHandler.new("host") do |ctx|
      text = ctx.text.to_s
      to_reply = agent.do_host(text)
      ctx.reply(to_reply) unless to_reply.nil?
    end

    whois_handler = Tourmaline::CommandHandler.new("whois") do |ctx|
      text = ctx.text.to_s
      to_reply = agent.do_whois(text)
      ctx.reply(to_reply) unless to_reply.nil?
    end

    nmap_handler = Tourmaline::CommandHandler.new("nmap") do |ctx|
      text = ctx.text.to_s.split(" ")
      host, port = text[0], text[1]
      if is :number?, port
        to_reply = agent.do_nmap(host, port.to_i)
      else
        Log.error { "*NMAP* wrong port: #{port}" }
        to_reply = "🤷‍♂️ Unknown port"
      end
      ctx.reply(to_reply) unless to_reply.nil?
    end

    dig_handler = Tourmaline::CommandHandler.new("dig") do |ctx|
      text = ctx.text.to_s.split(" ")
      host, type = text[0], text[1]
      type = "A" if type.empty?
      to_reply = agent.do_dig(host, type)
      ctx.reply(to_reply) unless to_reply.nil?
    end

    client.register(echo_handler, ping_handler, host_handler, whois_handler, nmap_handler, dig_handler)

    client.poll
  end
end
