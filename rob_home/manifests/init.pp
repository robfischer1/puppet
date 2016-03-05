include '::nfs::client'

class rob_home {

        ::nfs::client::mount { '/home':
          server  => '10.0.7.3',
          share   => '/mnt/stor0/users/home',
          mount   => '/home',
          #options => 'rw,context=unconfined_u:object_r:user_home_t:s0',
          options => 'rw,nosharecache,context=unconfined_u:unconfined_r:unconfined_t:s0',
        }

        file { '/etc/pam.d/su':
          ensure => file,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          content => file('rob_home/su'),
        }

        exec { 'setsebool':
                command => 'setsebool use_nfs_home_dirs 1',
                path    => '/usr/sbin/:/sbin/',
        }

}
