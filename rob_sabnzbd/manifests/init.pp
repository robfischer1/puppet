include 'docker'
include 'firewall'

class rob_sabnzbd {
	firewall {
		'052 Sabnzbd':
			proto  => 'tcp',
			dport  => [8080, 9090],
			action => 'accept';
	}

	::nfs::client::mount { 
		'/opt/sabnzbd':
			server  => '10.0.7.3',
			share   => '/mnt/stor0/users/home/sabnzbd',
			mount   => '/opt/sabnzbd',
			#options => 'rw,context=unconfined_u:object_r:user_home_t:s0',
			options => 'rw,nosharecache,context=system_u:system_r:svirt_sandbox_file_t:s0';
	}
	
	file {
		'/opt/sabnzbd/config':
			ensure => directory,
			mode   => 0775,
			owner  => sabnzbd,
			group  => media;

		'/opt/sabnzbd/downloads':
			ensure => directory,
			mode   => 0775,
			owner  => sabnzbd,
			group  => media;
	}

	docker::run {
		'sabnzbd':
			image           => 'linuxserver/sabnzbd',
			ports           => ['8080:8080', '9090:9090'],
			volumes         => ['/opt/sabnzbd/config:/config', '/opt/sabnzbd/downloads:/downloads'],
			env             => ['PUID=140800017', 'PGID=140800014'];
	}

}
