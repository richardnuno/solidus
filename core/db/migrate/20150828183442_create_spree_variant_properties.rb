class CreateSpreeVariantProperties < ActiveRecord::Migration
  def change
    create_table :spree_variant_properties do |t|
      t.text        :value
      t.references  :variant
      t.references  :property
      t.timestamps
      t.integer     :position,    default: 0
    end

    add_index :spree_variant_properties, :variant_id
    add_index :spree_variant_properties, :property_id
    add_index :spree_variant_properties, :position
  end
end
