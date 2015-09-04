module Spree
  class VariantProperty < Spree::Base
    acts_as_list
    has_many :variant_property_variants, foreign_key: "variant_property_id", dependent: :destroy, class_name: "Spree::VariantPropertyVariant"
    has_many :variants, through: :variant_property_variants
    belongs_to :variant, touch: true, class_name: 'Spree::Variant', inverse_of: :variant_properties
    belongs_to :property, class_name: 'Spree::Property', inverse_of: :variant_properties

    validates :property, presence: true
    validates_with Spree::Validations::DbMaximumLengthValidator, field: :value

    default_scope -> { order(:position) }

    self.whitelisted_ransackable_attributes = ['value']

    # virtual attributes for use with AJAX completion stuff
    def property_name
      property.name if property
    end

    def property_name=(name)
      unless name.blank?
        unless property = Property.find_by(name: name)
          property = Property.create(name: name, presentation: name)
        end
        self.property = property
      end
    end
  end
end
