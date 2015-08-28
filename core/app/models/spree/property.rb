module Spree
  class Property < Spree::Base
    has_and_belongs_to_many :prototypes, join_table: 'spree_properties_prototypes'

    has_many :variant_properties, dependent: :delete_all, inverse_of: :property
    has_many :variants, through: :variant_properties

    validates :name, :presentation, presence: true

    scope :sorted, -> { order(:name) }

    after_touch :touch_all_variants

    private

    def touch_all_variants
      variants.update_all(updated_at: Time.current)
    end
  end
end
