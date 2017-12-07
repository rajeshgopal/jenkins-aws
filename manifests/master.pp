#install jenkins as master

include jenkins

#run custom groovy script
$scriptdata = hiera('customscript')

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
    onlyif    => "until 'curl -s -o /dev/null -I http://localhost:8080/' ; do sleep 10  done",
    provider  => bash,
    require   => Service['jenkins']
   }
}
