#install jenkins as master

include jenkins

include master

exec { 'waitonmaster':
  command => 'sleep 60',
  path    => ['/bin'],
}

Class['jenkins'] -> Exec['waitonmaster'] -> Class['master']
