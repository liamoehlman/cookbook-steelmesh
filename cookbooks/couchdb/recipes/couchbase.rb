cookbook_file "/tmp/couchbase-single.rpm" do
  source "couchbase-single-server-community_x86_64_2.0.0-dev-preview-5.rpm"
  mode "0755"
  action :create_if_missing
end

package "couchbase-single" do
  action :install
  source "/tmp/couchbase-single.rpm"
  provider Chef::Provider::Package::Rpm
end