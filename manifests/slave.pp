# installs jenkins slave

include jenkins::slave

$list = lookup('packageslist')
$mavenarchive = lookup( { "name" => "mavenarchive", "default_value" => "http://www-us.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz" } )
$filename = "apache-maven-3.5.2-bin.tar.gz"

$list.each |$item| {
  package { "$item":
    ensure => installed,
  }
}

exec { 'maven-install-from-archive':
  path    => ['/bin', '/usr/bin'],
  command => "tar -xf $filename -C /opt/maven --strip-components=1",
  cwd     => '/opt',
  onlyif  => "mkdir maven && wget $mavenarchive",
}

yumrepo { 'docker-repo':
  enabled  => 1,
  descr    => 'Docker CE repo',
  baseurl  => 'https://download.docker.com/linux/centos/',
  gpgcheck => 0,
}
yumrepo { 'rhel-extras':
  enabled  => 1,
  descr    => 'Docker CE repo',
  baseurl  => 'https://download.docker.com/linux/centos/',
  gpgcheck => 0,
}

service { 'docker':
  ensure => running,
  require => Package['docker-ce']
}

Yumrepo <| |> -> Package <| |> -> Service['docker']
