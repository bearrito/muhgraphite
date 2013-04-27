default[:install][:directory] 		= "/opt"


default[:auth][:graphiteuser]	= "graphite"
default[:auth][:graphitegroup]	= "graphite"

default[:graphite][:version]       	= "0.9.10"
default[:graphite][:packages][:deb]	= ["memcached","python","python-pip","python-memcache","python-rrdtool","nginx","python-simplejson","fontconfig","python-zopeinterface","python-django","python-django-tagging","python-twisted" ,"python-twisted-web","python-cairo" ,"python-cairo-dev" , "python-setuptools" ,"build-essential" ,"python-dev"]
default[:graphite][:packages][:pip]  	= ["carbon","graphite-web","uwsgi","whisper"]
 

