module Pingasius
  class Agent
    Log = ::Log.for("agent")

    def initialize(@options : Pingasius::Options)
      Log.level = :debug if @options.settings.debug?
    end

    def commands_available
      "```\n⛑️\n" +
        "/host domain|ip - returns DNS name or IP\n" +
        "/ping domain|ip - pings DNS name or IP\n" +
        "/whois domain|ip - whois for domain or IP\n" +
        "/nmap domain|ip port - nmap single port of domain or IP\n" +
        "/dig domain type - dig domain\n" +
        "```"
    end

    def do_ping(ip : String)
      unless (is :ip?, ip) || (is :domain?, ip)
        Log.error { "*PING* wrong input: #{ip}" }
        return "🤷‍♂️ `Not an IP address or domain`"
      end
      io, error = IO::Memory.new, IO::Memory.new
      proc = Process.new("ping", args: {"-c", "1", "-W", "1", ip}, output: io, error: error)
      case proc.wait
      when .success?
        "✅ ```#{io}```"
      else
        Log.error { "#{io} #{error}" }
        "🔥 ```#{io}```"
      end
    end

    def do_host(ip : String)
      unless (is :ip?, ip) || (is :domain?, ip)
        Log.error { "*HOST* wrong input: #{ip}" }
        return "🤷‍♂️ `Not an IP address or domain`"
      end
      io, error = IO::Memory.new, IO::Memory.new
      proc = Process.new("host", args: {"-t", "a", "-W", "1", ip}, output: io, error: error)
      case proc.wait
      when .success?
        "✅ ```#{io}```"
      else
        Log.error { "#{io} #{error}" }
        "🔥 ```#{io}```"
      end
    end

    def do_whois(ip : String)
      unless (is :ip?, ip) || (is :domain?, ip)
        Log.error { "*HOST* wrong input: #{ip}" }
        return "🤷‍♂️ `Not an IP address or domain`"
      end
      io, error = IO::Memory.new, IO::Memory.new
      proc = Process.new("whois", args: {ip}, output: io, error: error)
      case proc.wait
      when .success?
        "✅ ```#{io}```"
      else
        Log.error { "#{io} #{error}" }
        "🔥 ```#{io}```"
      end
    end

    def do_nmap(ip : String, port : Int32)
      unless (is :ip?, ip) || (is :domain?, ip)
        Log.error { "*HOST* wrong input: #{ip}" }
        return "🤷‍♂️ `Not an IP address or domain`"
      end
      io, error = IO::Memory.new, IO::Memory.new
      proc = Process.new("nmap", args: {"-sV", "-Pn", "--noninteractive", "--reason", ip, "-p", port.to_s}, output: io, error: error)
      case proc.wait
      when .success?
        "✅ ```#{io}```"
      else
        Log.error { "#{io} #{error}" }
        "🔥 ```#{io}```"
      end
    end

    def do_dig(domain : String, type : String)
      unless is :domain?, domain
        Log.error { "*HOST* wrong input: #{domain}" }
        return "🤷‍♂️ `Not a domain`"
      end
      io, error = IO::Memory.new, IO::Memory.new
      proc = Process.new("dig", args: {"+short", domain, type.to_s}, output: io, error: error)
      case proc.wait
      when .success?
        "✅ ```#{io}```"
      else
        Log.error { "#{io} #{error}" }
        "🔥 ```#{io}```"
      end
    end
  end
end
