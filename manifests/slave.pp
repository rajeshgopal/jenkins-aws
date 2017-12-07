# installs jenkins slave

include jenkins::slave

$list = hiera('packageslist')
package { "$list":
  ensure => installed,
  }

