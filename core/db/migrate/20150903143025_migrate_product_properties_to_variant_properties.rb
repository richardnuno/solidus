class MigrateProductPropertiesToVariantProperties < ActiveRecord::Migration
  disable_ddl_transaction!

  class Spree::ProductProperty < Spree::Base
    belongs_to :product, class_name: 'Spree::Product'
    belongs_to :property, class_name: 'Spree::Property'
  end

  def up
    Spree::ProductProperty.includes(product: :master).find_each do |product_property|
      master_variant = product_property.product.master
      puts "Migrating product property with id ##{product_property.id}"
      Spree::VariantProperty.create!(
        variants: [master_variant],
        value: product_property.value,
        property: product_property.property,
        position: product_property.position
      )
    end
  end

  def down
    Spree::VariantProperty.delete_all
  end
end
