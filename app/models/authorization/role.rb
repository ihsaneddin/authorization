module Authorization
  class Role < ApplicationRecord

    has_and_belongs_to_many Authorization.role.entity_relation_name, class_name: Authorization.role.entity_class, :join_table => Authorization.role.join_table, foreign_key: :role_id, association_foreign_key: :entity_id

    include Authorization::Permissions::Concerns::Models::Role

    validates :name, presence: true

  end
end
