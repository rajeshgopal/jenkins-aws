# installs jenkins slave

include jenkins::slave

$list = lookup('packageslist')
$mavenarchive = lookup( { "name" => "mavenarchive", "default_value" => "http://www-us.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz" } )
$terraformzip = lookup( { "name" => "terraformzip", "default_value" => "https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_linux_amd64.zip" } )

$list.each |$item| {
  package { "$item":
    ensure => installed,
  }
}
if $terraformzip =~ /(.*\/)(.*\.*)/ {
  archive { "/tmp/$2":
    source       => "$terraformzip",
    extract      => true,
    extract_path => '/usr/local/bin',
    creates      => '/usr/local/bin/terraform',
    user         => 'jenkins-slave',
    group        => 'jenkins-slave',
    cleanup      => true,
  }
}

if $mavenarchive =~ /(.*\/)(.*\.*)/ {
  exec { 'maven-install-from-archive':
    path    => ['/bin', '/usr/bin'],
    command => "tar -xf $2 -C /opt/maven --strip-components=1",
    cwd     => '/opt',
    onlyif  => "mkdir maven && wget $mavenarchive",
    require => Package['wget']
  }
}

yumrepo { 'docker-repo':
  enabled  => 1,
  descr    => 'Docker CE repo',
  baseurl  => 'https://download.docker.com/linux/centos/7/x86_64/stable',
  gpgcheck => 0,
}
exec { 'rhel-extras-repo':
  path  => ['/bin', '/usr/bin'],
  command => 'yum -y --enablerepo=rhui-REGION-rhel-server-extras install container-selinux',
  before  => Yumrepo['docker-repo']
  }

service { 'docker':
  ensure => running,
  require => Package['docker-ce']
}

Yumrepo['docker-repo'] -> Package <| |> -> Service['docker'] -> Class['jenkins::slave'] 
