cmd_prefix = "GEM_HOME=#{status.gem_home} RACK_ENV=#{node.environment.framework_env}"

[
  ["#{release_path}/tmp/pids", "#{shared_path}pids"],
  ["#{release_path}/log", "#{shared_path}log"],
  ["#{release_path}/public/uploads", "#{shared_path}uploads"]
].each do |source, dest|
  directory dest do
    owner app[:user]
    group app[:user]
    mode 0777
    always_run true
  end
  link source do
    to dest
    owner app[:user]
    group app[:user]
    always_run true
  end
end

