module MCollective
  module RPC
    # So ya, the ruby syslog library limit's the number of syslog
    # handles to 1 per ruby instance.  We configure mcollective to log
    # via syslog so some quick math... That's why in this audit plugin
    # we are shelling out to `logger`.
    #
    #  Settings for /etc/mcollective/server.cfg
    #
    #  rpcauditprovider = Auditlogger
    #  plugin.rpcaudit.auditlogger.facility = local2
    #  plugin.rpcaudit.auditlogger.priority = info
    #
    class Auditlogger<Audit
      require 'pp'

      def audit_request(request, connection)

        facility = Config.instance.pluginconf["rpcaudit.auditlogger.facility"] || 'local2'
        priority = Config.instance.pluginconf["rpcaudit.auditlogger.priority"] || 'info'

        now = Time.now
        now_tz = tz = now.utc? ? "Z" : now.strftime("%z")
        now_iso8601 = "%s.%06d%s" % [now.strftime("%Y-%m-%dT%H:%M:%S"), now.tv_usec, now_tz]

        %x[/usr/bin/logger -p #{facility}.#{priority} "#{now_iso8601}: reqid=#{request.uniqid}: reqtime=#{request.time} caller=#{request.caller}@#{request.sender} agent=#{request.agent} action=#{request.action} data=#{request.data.pretty_print_inspect}"]
      end
    end
  end
end
