module Spree
  module Admin
    class VariantPropertiesController < ResourceController
      belongs_to 'spree/product', :find_by => :slug
      before_action :find_properties
      before_action :setup_property, only: :index, if: -> { can?(:create, model_class) }
      before_action :load_option_values, only: :index
      before_action :load_variant_properties, only: :index

      def update_product
        @product.master.update_attributes!(bulk_permitted_params[:master])
        redirect_to admin_product_variant_properties_url(@product)
      end

      def update_variants
        variant_ids = params[:filtered_variant_ids].split
        variant_properties = params.require(:variant).permit![:variant_properties_attributes].values
        Spree::VariantProperty.transaction do
          # TODO - variant_property will not get deleted if all associations are deleted
          Spree::VariantPropertyVariant.where(variant_id: variant_ids).destroy_all
          variant_properties.each do |vp|
            next if vp[:property_name].blank?
            variant_property = vp[:id].present? ? Spree::VariantProperty.find(vp[:id]) : Spree::VariantProperty.new
            variant_property.attributes = vp
            variant_property.variant_ids = variant_ids
            variant_property.save!
          end
        end
        redirect_to admin_product_variant_properties_url(@product)
      end

      private

      def find_properties
        @properties = Spree::Property.pluck(:name)
      end

      def setup_property
        @product.master.variant_properties.build
      end

      def load_option_values
        @option_types = @product.variant_option_types
      end

      def load_variant_properties
        @variant_properties = []
        @option_value_ids = (params[:ovi] || []).reject(&:blank?)
        if @option_value_ids.present?
          @variant_ids = @product.variants.joins(:option_values).where(spree_option_values: { id: @option_value_ids }).group("spree_variants.id").having("count(spree_option_values.id) = ?", @option_value_ids.size).pluck(:id)
          variant_property_ids = Spree::VariantPropertyVariant.select(:variant_property_id).where(variant_id: @variant_ids).group(:variant_property_id).having("count(variant_id) = ?", @variant_ids.count).pluck(:variant_property_id)
          @variant_properties = Spree::VariantProperty.includes(:property).where(id: variant_property_ids).order(:position).uniq
          @variant_properties << Spree::VariantProperty.new
        end
      end

      def bulk_permitted_params
        params.require(:product).permit!
      end

      def collection_actions
        super + [:update_product, :update_variants]
      end
    end
  end
end
