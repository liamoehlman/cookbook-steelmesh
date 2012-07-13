### Copy over couchdb's already created init files
file "/etc/init.d/couchdb" do
  content IO.read(node[:couch][:init])
  owner "root"
  group "root"
  action :create
end

file "/etc/logrotate.d/couchdb" do
  content  IO.read(node[:couch][:logrotate])
  owner "root"
  group "root"
  action :create
end  

