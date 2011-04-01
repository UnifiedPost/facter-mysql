# mysql.rb
# Facts related to MySQL status
#
# Frederic -lefred- Descamps
# <lefred.descamps@gmail.com>
# http://www.lefred.be/

# this code is hosted on github :

# this file should be installed in your facter directory, for example on a fedora 14 it is
# in /usr/lib/ruby/site_ruby/1.8/facter
 
# mysql command line to execute queries
mysqlcmd = 'mysql -B -N -e'
 
Facter.add(:mysql_version) do
  setcode do
    isinstalled = false
    os = Facter.value('operatingsystem')
    case os
      when "RedHat", "CentOS", "SuSE", "Fedora"
        isinstalled = system "rpm -q mysql >/dev/null 2>&1"
      when "Debian", "Ubuntu"
        isinstalled = system "dpkg -l mysql-server 2>&1 | egrep '(^ii|^hi)' >/dev/null"
      else
    end
    if isinstalled then
      %x[#{mysqlcmd} "SELECT VERSION()"].to_s.strip
    end
  end
end

mysqlversion = Facter.value('mysql_version')

if mysqlversion then
  Facter.add(:mysql_threads_connected) do
    setcode do
      threadsconnected = %x[#{mysqlcmd} "SHOW STATUS LIKE 'threads_connected'"].to_s.strip
      threadsconnected.sub('Threads_connected','').strip
    end
  end
end