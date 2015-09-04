class CreateSpreeVariantProperties < ActiveRecord::Migration
  def change
    create_table :spree_variant_properties do |t|
      t.text        :value
      t.references  :property
      t.timestamps
      t.integer     :position,    default: 0
    end

    add_index :spree_variant_properties, :property_id
    add_index :spree_variant_properties, :position

    create_table :spree_variant_property_variants do |t|
      t.references :variant
      t.references :variant_property
      t.timestamps
    end

    add_index :spree_variant_property_variants, [:variant_id, :variant_property_id], name: "index_spree_variant_property_variants_on_variant_and_prop_id"
  end
end
