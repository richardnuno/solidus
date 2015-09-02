namespace 'spree:migrations:migrate_variant_properties' do
  # This creates a VariantProperty for each ProductProperty
  # by using the products master variant and copying over
  # the rest of the attributes.

  task up: :environment do
    if Spree::VariantProperty.any?
      raise "Task should only be run to migrate product properties"
    end
    # ProductProperty is no longer defined so
    # redefine it for the rake task execution
    class Spree::ProductProperty < Spree::Base
      belongs_to :product, class_name: 'Spree::Product'
      belongs_to :property, class_name: 'Spree::Property'
    end

    Spree::ProductProperty.includes(product: :master).find_each do |product_property|
      master_variant = product_property.product.master
      # TODO - test find_or_create_by
      # TODO - should this really be a rake task?
      puts "Migrating product property with id ##{product_property.id}"
      Spree::VariantProperty.find_or_create_by!(
        variant: master_variant,
        value: product_property.value,
        property: product_property.property,
        position: product_property.position
      )
    end
  end

  task down: :environment do
    Spree::VariantProperty.delete_all
  end
end
