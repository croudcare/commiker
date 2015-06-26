module Configs

  def self.load(config_path, env = "development")
    @config = YAML.load_file(config_path)[env.to_s]
    @config["environment"] = env
  end

  def self.[](key)
    return "Key '#{key}' is not defined in config.yml" unless @config.has_key?(key)

    @config[key]
  end

  def self.to_h
    @config || {}
  end

end
