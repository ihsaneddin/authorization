require 'authorization/roles/adapters/base'
require 'authorization/roles/dynamic'
require 'authorization/roles/resource'
require 'authorization/roles/role_methods'
require 'authorization/configuration'

module Authorization::Roles

  attr_accessor :role_cname, :adapter, :resource_adapter, :role_join_table_name, :role_table_name, :strict_role
  @@resource_types = []

  def has_roles(options = {})
    include RoleMethods
    extend Dynamic if Authorization.role.dynamic_shortcuts

    options.reverse_merge!({:role_cname => 'Authorization::Role'})
    self.role_cname = options[:role_cname]
    self.role_table_name = self.role_cname.tableize.gsub(/\//, "_")

    default_join_table = "authorization_entities_roles"
    options.reverse_merge!({:role_join_table_name => default_join_table})
    self.role_join_table_name = options[:role_join_table_name]

    role_options = { :class_name => options[:role_cname].camelize }
    role_options.merge!({ :join_table => self.role_join_table_name, foreign_key: :entity_id, association_foreign_key: :role_id })
    role_options.merge!(options.reject{ |k,v| ![ :before_add, :after_add, :before_remove, :after_remove, :inverse_of ].include? k.to_sym })

    has_and_belongs_to_many :roles, **role_options

    self.adapter = Authorization::Roles::Adapters::Base.create("role_adapter", self.role_cname, self.name)
    self.strict_role = true if options[:strict]
  end

  def adapter
    return self.superclass.adapter unless self.instance_variable_defined? '@adapter'
    @adapter
  end

  def resource_role(association_name = :roles, options = {})
    include Resource

    options.reverse_merge!({ :role_cname => 'Authorization::Role', :dependent => :destroy })
    resourcify_options = { :class_name => options[:role_cname].camelize, :as => :resource, :dependent => options[:dependent] }
    self.role_cname = options[:role_cname]
    self.role_table_name = self.role_cname.tableize.gsub(/\//, "_")

    has_many association_name, **resourcify_options

    self.resource_adapter = Authorization::Roles::Adapters::Base.create("resource_adapter", self.role_cname, self.name)
    @@resource_types << self.name
  end

  def resource_adapter
    return self.superclass.resource_adapter unless self.instance_variable_defined? '@resource_adapter'
    @resource_adapter
  end

  def scopify
    require "authorization/roles/adapters/scopes.rb"
    extend Authorization::Roles::Adapters::Scopes
  end

  def role_class
    return self.superclass.role_class unless self.instance_variable_defined? '@role_cname'
    self.role_cname.constantize
  end

  def self.resource_types
    @@resource_types
  end

end
