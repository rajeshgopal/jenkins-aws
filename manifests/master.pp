#install jenkins as master

include jenkins

#run custom groovy script
$scriptdata = lookup('customscript')

exec { 'sleep120':
  command => 'sleep 120',
  path    => ['/bin'],
  require => Service['jenkins'],
  before  => Exec["$script"],
}

$scriptdata.each |$item| {

  $input = $item[data]
  $script = $item[script]

  file { "/tmp/$script.groovy":
    ensure  => present,
    content => template("master/$script.groovy"),
    before  => Exec["$script"]
  }
  exec { "$script":
    path      => ['/usr/bin','usr/local/bin','/bin'],
    command   => "curl -d \"script=\$(cat /tmp/$script.groovy)\"  http://localhost:8080/scriptText",
    logoutput => true,
    onlyif    => "/usr/bin/wget --spider --tries 30 --retry-connrefused http://localhost:8080/",
    provider  => 'shell',
    require   => Service['jenkins']
  }
}
