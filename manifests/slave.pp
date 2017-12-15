# installs jenkins slave

include jenkins::slave

$list = lookup('packageslist')
$mavenarchive = lookup( { "name" => "mavenarchive", "default_value" => "http://www-us.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz" } )

$list.each |$item| {
  package { "$item":
    ensure => installed,
  }
}
# tar striping directories:
archive { "$mavenarchive":
  ensure          => present,
  extract         => true,
  extract_command => 'tar -xf %s --strip-components=1',
  extract_path    => '/opt/maven',
  cleanup         => true,
  creates         => '/opt/maven',
}
