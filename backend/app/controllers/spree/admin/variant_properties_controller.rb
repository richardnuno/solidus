module Spree
  module Admin
    class VariantPropertiesController < ResourceController
      belongs_to 'spree/product', :find_by => :slug
      before_action :find_properties
      before_action :setup_property, only: :index, if: -> { can?(:create, model_class) }
      before_action :load_option_values, only: :index
      before_action :load_variant_properties, only: :index

      def update_product
        #@product.master.update_attributes!(bulk_permitted_params[:master])
        debugger
        redirect_to admin_product_variant_properties_url(@product)
      end

      def update_variants
        variants = @product.variants.where(id: params[:filtered_variant_ids].split)
        variant_properties = params.require(:variant).permit!
        Spree::VariantProperty.transaction do
          variants.each do |variant|
            variant.update_attributes!(variant_properties)
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
        @option_value_ids = (params[:ovi] || []).reject(&:blank?)
        if @option_value_ids.present?
          @variant_ids = @product.variants.joins(:option_values).where(spree_option_values: { id: @option_value_ids }).group("spree_variants.id").having("count(spree_option_values.id) = ?", @option_value_ids.size).pluck(:id)
          @variant_properties = Spree::VariantProperty.where(variant_id: @variant_ids).order(:position).uniq
          @variant_properties << @variant_properties.build
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
