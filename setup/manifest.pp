
# Lets tell Puppet the order of our stages
stage {
    'update': before => Stage['repos'];
    'repos': before => Stage['updates'];
    'updates': before => Stage['packages'];
    'packages': before => Stage['services'];
    'services': before => Stage['configure'];
    'configure': before => Stage['startapi'];
    'startapi': before => Stage['main'];
}
 
class services {
    #we mongo to be running when the server boots
    service {
        'mongodb':
            ensure => running,
            enable => true;
	'redis-server':
	    ensure => running,
	    enable => true;
    }
}

class packages {
    package {
        "mongodb-10gen": ensure => "present"; # MongoDB
        "nodejs": ensure => "present";
	"redis-server":ensure => "present"
    }
}

class update {
    # We must run apt-get update before we install our packaged because we installed some repo's
    exec { "apt-updates":
        command => "/usr/bin/apt-get update -y",
        timeout => 0
    }
}
 
class updates {
    # We must run apt-get update before we install our packaged because we installed some repo's
    exec { "apt-update":
        command => "/usr/bin/apt-get update -y",
        timeout => 0
    }
}
 
class repos {
    #install some repos
    exec {
        "get-mongo-key" :
            # same as key installation above
            command => "/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10";
            #unless => "/usr/bin/apt-key list| /bin/grep -c 10gen";
        # now lets install some repo's
        "install-mongo-repo":
            require => Exec["get-mongo-key"],
            #we are doing the same thing as we did with the other repo above.
            command => "/bin/echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | /usr/bin/tee /etc/apt/sources.list.d/10gen.list";
            #unless => "/bin/grep 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart' -c /etc/apt/sources.list";
        "chris-lea":
            command => "/usr/bin/apt-get install -y python-software-properties python g++ make";
        "node-repo":
            require => Exec["chris-lea"],
            command => "/usr/bin/add-apt-repository -y ppa:chris-lea/node.js";
	"redis-repo":
	    require => Exec["chris-lea"],
	    command => "/usr/bin/add-apt-repository -y ppa:rwky/redis";
    }

}

class configure {
    exec {
    "node-forever":
        command => "/usr/bin/npm install forever -g";
    }
}

class startapi{
    exec {
    "start-api":
        #command => "/usr/bin/forever start /vagrant/app.js",
        command => "/usr/bin/node /vagrant/app.js &",
        environment => "NODE_ENV=test";
    }
}
 
# Here we are linking our classes to stages
class {
    # class: stage => "stagename";
    update: stage => "update";
    repos: stage => "repos";
    updates: stage => "updates";
    packages: stage => "packages";
    services: stage => "services";
    configure: stage => "configure";
    startapi: stage => "startapi";
}
