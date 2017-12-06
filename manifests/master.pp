#install jenkins as master

class { 'jenkins':
  slaveagentport => 0 + $::slaveport,
  }
include jenkins::security
