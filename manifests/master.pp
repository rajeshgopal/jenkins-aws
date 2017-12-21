#install jenkins as master

include jenkins

include master

exec { 'waitonmaster':
  command => 'sleep 60',
  path    => ['/bin'],
}

exec { 'addjob':
  command => "curl -s -XPOST 'http://localhost:8080/createItem?name=sample-maven-artifactory-job' --data-binary @maven-sample-job.xml -H 'Content-Type:text/xml' ",
  path    => ['/usr/bin', '/bin'],
  cwd     => '/opt/garage/modules/master/files',
}
exec { 'addjob':
  command => "curl -s -XPOST 'http://localhost:8080/createItem?name=docker-build-pipeline-job' --data-binary @docker-build-pipeline.xml -H 'Content-Type:text/xml' ",
  path    => ['/usr/bin', '/bin'],
  cwd     => '/opt/garage/modules/master/files',
}

Class['jenkins'] -> Exec['waitonmaster'] -> Exec['addjob'] -> Class['master']
