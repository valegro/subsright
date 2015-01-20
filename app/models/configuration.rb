class Configuration < ActiveRecord::Base
  serialize :value
  has_attached_file :provider_logo
  do_not_validate_attachment_file_type :provider_logo

  class_attribute :settings
  self.settings = []

  def self.ensure_created
    self.settings.each do |setting|
      self.send(setting)
    end
    provider_logo
  end

  def self.setting(name, default, form_type, form_collection_command="")
    class_eval <<-EOC
      self.settings << "#{name}"
      def self.#{name}
        @#{name} ||= (
          self.find_or_create_by(key: "#{name}") do |config|
            config.value = #{default}
            config.form_type = "#{form_type}"
            config.form_collection_command = "#{form_collection_command}"
          end
        ).value
      end
      def self.#{name}=(value)
        config = self.find_or_create_by(key: "#{name}")
        config.value = value
        config.save!
        @#{name} = value
      end
    EOC
  end

  # Accessors for provider_logo class attribute
  def self.provider_logo
    find_or_create_by(key: 'provider_logo', form_type: 'file').provider_logo
  end

  def self.provider_logo=(attachment)
    config = find_by(key: 'provider_logo')
    config.provider_logo = attachment
    config.value = config.provider_logo.original_filename
    config.save!
  end

  # Accessors for provider_logo_file_name instance attribute
  def provider_logo_file_name
    config = Configuration.find_by(key: 'provider_logo')
    config.value if config
  end

  def provider_logo_file_name=(file_name)
    config = Configuration.find_by(key: 'provider_logo')
    config.value = file_name
    config.save!
    return file_name
  end

  # Define settings by listing them here
  setting :provider_name, "'Organisation Name'", :string

  # Ensure all the defaults are created when the class file is read
  self.ensure_created if connection.table_exists? configurations
end
