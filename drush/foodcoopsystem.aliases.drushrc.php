<?php
// $options['ssh-options'] = '-o PasswordAuthentication=yes';

// Local.
$aliases['local'] = array(
  'root' => '/var/www',
  'uri' => 'www.foodcoopsystem.local',
  'remote-host' => 'www.foodcoopsystem.local',
  'remote-user' => 'root',
  'ssh-options' => "-p 9022",
  'databases' => array(
    'default' => array(
      'default' => array(
        'driver' => 'mysql',
        'database' => 'foodcoop',
        'username' => 'root',
        'password' => 'root',
        'host' => '127.0.0.1',
        'prefix' => '',
      ),
    ),
  ),
);
