Auditlogger Audit Plugin
=============================

This is a plugin that logs audit messages to syslog using the `logger` command.  The native ruby syslog library only allows 1 syslog handle to be open per process so you cannot configure mcollective to log to syslog and use a syslog audit plugin.   This plugin just takes the standard audit payload that comes with the default audit plugins and passes them to the `logger` command. 

Installation
=============================

  * Follow the [basic plugin install guide](http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/InstalingPlugins) by placing 
 auditlogger.rb and auditlogger.ddl in the audit directory.

  * You can also use 'mco plugin package' to build a package.
  mco plugin package mcollective-auditlogger-audit

Configuration
=============================

At a minimum you need to define the following in your server.cfg

    rpcauditprovider = Auditlogger

You can also control the facility and priority to log at.  If you don't set anything you'll get 'local2' and 'info' by default.

    plugin.rpcaudit.auditlogger.facility = local2
    plugin.rpcaudit.auditlogger.priority = info

Example
=============================

The log payload is exactly the same as most of the other audit plugins.  Here is an example of a log entry after it's going through syslog and into the respective log file.

2013-06-10T22:59:46.165275+00:00 servername user: 2013-06-10T22:59:46.157941+0000: reqid=bee2194c8ea6545c8227eb5b6a04c538: reqtime=1370905186 caller=cert=user@servername.domain agent=mgrep action=search data={:pattern=>localhost, :file=>/etc/hosts, :process_results=>true}
