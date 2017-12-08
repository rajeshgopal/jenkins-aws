#class for configuring jenkins using groovy scripts
## Example Hiera Data
#master::settings:
#  user:
#    script: add_user
#    data:
#      - user: admin
#        passwd: "%{::masterpwd}"
#      - user: "%{::slaveuser}"
#        passwd: "%{::slavepwd}"
#  executor:
#    script: set_executors
#    data:
#      count: 0
#  agent:
#    script: set_slaveport
#    data:
#      slaveport: "%{::slaveport}"
#  security:
#    script: set_security
#    data:
#      model: fullcontrol

class master(
  Optional[Hash] $settings = undef,
  String $host = "http://localhost:8080"
 ){

 if !empty($settings) {

   package { 'wget':
     ensure => installed,
   }
   
   Package['wget'] -> Exec <||>
   
   $settings.each |$key, $item| {

     $input = $item[data]
     $script = $item[script]

     file { "/tmp/$script.groovy":
       ensure  => present,
       content => template("master/$script.groovy"),
       before  => Exec["$script"]
     }
     exec { "$script":
       path      => ['/usr/bin','usr/local/bin','/bin'],
       command   => "curl -d \"script=\$(cat /tmp/$script.groovy)\"  ${host}/scriptText",
       logoutput => true,
       onlyif    => "/usr/bin/wget --spider --tries 30 --retry-connrefused ${host}",
       provider  => 'shell',
     }
   }
 }
}
