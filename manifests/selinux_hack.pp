# selinux hack to let mongod have the socket

class mongodb::selinux_hack
{

  file {'/tmp/mongodb_hack.te' :
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/${module_name}/tmp/mongodb_hack.te",
  }

  exec { 'mongod-checkmodule' :
    command     => '/usr/bin/checkmodule -M -m -o /tmp/mongodb_hack.mod /tmp/mongodb_hack.te',
    refreshonly => true,
    subscribe   => File['/tmp/mongodb_hack.te'],
  }

  exec { 'mongod-package' :
    command     => '/usr/bin/semodule_package -o /tmp/mongodb_hack.pp -m /tmp/mongodb_hack.mod',
    refreshonly => true,
    subscribe   => Exec['mongod-checkmodule'],
  }

  exec { 'mongod-semodule' :
    command     => '/usr/sbin/semodule -i /tmp/mongodb_hack.pp',
    refreshonly => true,
    subscribe   => Exec['mongod-package'],
  }

}

