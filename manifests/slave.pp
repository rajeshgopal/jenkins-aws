# installs jenkins slave

include jenkins::slave

$list = lookup('packageslist')
$list.each |$item| {
  package { "$item":
    ensure => installed,
  }
}

