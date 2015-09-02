FactoryGirl.define do
  factory :variant_property, class: Spree::VariantProperty do
    variant
    property
  end
end
