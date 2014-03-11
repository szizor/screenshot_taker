::APP_CONFIG = YAML.load_file("#{Rails.root}/config/amazon.yml")[Rails.env].symbolize_keys!
