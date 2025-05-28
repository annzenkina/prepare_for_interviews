require 'yaml'

def is_enabled?(user_id, flag_key, env:, service:)
  config = YAML.load_file('data.yml')
  # Find the specific flag configuration by flag_key under feature_flags
  flag_config = config['feature_flags'][flag_key]
  
  # Return false if flag configuration doesn't exist
  return false unless flag_config
  
  # Check override priority: user > env > service
  if flag_config['overrides']
    if flag_config['overrides'].key?("user:#{user_id}")
      return flag_config['overrides']["user:#{user_id}"]
    elsif flag_config['overrides'].key?("env:#{env}")
      return flag_config['overrides']["env:#{env}"]
    elsif flag_config['overrides'].key?("service:#{service}")
      return flag_config['overrides']["service:#{service}"]
    end
  end

  flag_config["default"]
end

puts(is_enabled?("alice", "new_checkout_ui", env: "production", service: "search-api"))
# => true (user-specific override)

puts(is_enabled?("bob", "dark_mode", env: "production", service: "search-api"))
# => false (user-specific override)

puts(is_enabled?("charlie", "dark_mode", env: "production", service: "checkout"))
# => false (env override)

puts(is_enabled?("dan", "dark_mode", env: "staging", service: "checkout"))
# => true (uses default)

