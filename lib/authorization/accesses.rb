module Authorization::Accesses

  attr_accessor :access_cname, :access_join_table_name

  def has_accesses(options = {})
    self.access_cname = "Authorization::Access"
    self.access_join_table_name = "authorization_entities_accesses"
    has_and_belongs_to_many :accesses, class_name: "Authorization::Access", :join_table => self.access_join_table_name, foreign_key: :entity_id, association_foreign_key: :access_id
  end

end
