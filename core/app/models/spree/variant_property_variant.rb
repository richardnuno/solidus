module Spree
  class VariantPropertyVariant < Spree::Base
    belongs_to :variant, touch: true, class_name: 'Spree::Variant', inverse_of: :variant_property_variants
    belongs_to :variant_property, class_name: 'Spree::VariantProperty', inverse_of: :variant_property_variants
  end
end
