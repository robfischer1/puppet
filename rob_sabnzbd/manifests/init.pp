include 'docker'
include 'firewall'

class rob_sabnzbd {
        firewall {
                '052 Sabnzbd':
                        proto  => 'tcp',
                        dport  => [8080, 9090],
                        action => 'accept';
        }

        file {
                '/home/sabnzbd/config':
                        ensure => directory,
                        mode   => 0775,
                        owner  => sabnzbd,
                        group  => media;

                '/home/sabnzbd/downloads':
                        ensure => directory,
                        mode   => 0775,
                        owner  => sabnzbd,
                        group  => media;
        }

        docker::run {
                'sabnzbd':
                        image           => 'linuxserver/sabnzbd',
                        ports           => ['8080:8080', '9090:9090'],
                        volumes         => ['/home/sabnzbd/config:/config:Z', '/home/sabnzbd/downloads:/downloads:z'],
                        privileged      => true,
                        #volumes         => ['10.0.7.3/mnt/stor0/users/home/sabnzbd/config:/config:Z', '10.0.7.3/mnt/stor0/users/home/sabnzbd/downloads:/downloads:z'],
                        #volumes         => ['/opt/config:/config:Z', '/home/sabnzbd/downloads:/downloads:z'],
                        #volumes         => ['/home/sabnzbd/downloads:/downloads:z'],
                        env             => ['PUID=140800017', 'PGID=140800014'],
                        #extra_parameters => ['--volume-driver=nfs'];
        }

}
