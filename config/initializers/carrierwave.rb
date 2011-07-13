file = Rails.root.join('config', 'carrierwave.yml')
config = YAML.load(ERB.new(File.read(file)).result)[Rails.env]

CarrierWave.configure do |carrierwave|
  carrierwave.fog_credentials = {
    :provider => 'AWS',
    :aws_access_key_id => config['access_key'],
    :aws_secret_access_key => config['secret_access_key']
  }
  carrierwave.fog_directory = config['bucket']
  carrierwave.storage = :fog
end

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
