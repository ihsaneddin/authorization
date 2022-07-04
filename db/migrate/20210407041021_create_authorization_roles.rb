class CreateAuthorizationRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :authorization_roles do |t|
      t.string :name
      t.references :resource, :polymorphic => true
      t.text :permissions
      t.timestamps
    end
    create_table :authorization_entities_roles, :id => false do |t|
      t.references :entity
      t.references :role
    end
  end
end
