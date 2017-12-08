# installs jenkins slave

include jenkins::slave

$list = lookup('packageslist')
package { "$list":
  ensure => installed,
  }

