#install jenkins as master

include jenkins

include master

exec { 'waitonmaster':
  command => 'sleep 120',
  path    => ['/bin'],
}

Class['jenkins'] -> Exec['waitonmaster'] -> Class['master']
