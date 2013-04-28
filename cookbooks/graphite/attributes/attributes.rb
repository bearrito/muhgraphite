default[:install][:directory] 		= "/opt"


default[:auth][:graphiteuser]	= "www-user"
default[:auth][:graphitegroup]	= "www-group"

default[:graphite][:version]       	= "0.9.10"
default[:graphite][:packages][:deb]	= ["supervisor","nginx","memcached","python","python-pip","python-memcache","python-rrdtool","nginx","python-simplejson","fontconfig","python-zopeinterface","python-django","python-django-tagging","python-twisted" ,"python-twisted-web","python-cairo" ,"python-cairo-dev" , "python-setuptools" ,"build-essential" ,"python-dev"]
default[:graphite][:packages][:pip]  	= ["pexpect","carbon","graphite-web","uwsgi","whisper"]


default[:graphite][:initscripts] = ["carbon","nginx"]
default[:graphite][:supervisorscripts] = ["uwsgi.conf"]

default[:graphite][:django][:dbuser] = "djangodb" 
default[:graphite][:djagno][:dbuseremail] = "j.barrett.strausser@gmail.com" 
default[:graphite][:djagno][:dbuserpassword] = "adar323sd445"
