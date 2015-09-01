module Spree
  module Admin
    class VariantPropertiesController < ResourceController
      belongs_to 'spree/product', :find_by => :slug
      before_action :find_properties
      before_action :setup_property, only: :index, if: -> { can?(:create, model_class) }
      before_action :load_option_values, only: :index

      def bulk_update
        debugger
        #@product.master.update_attributes!(bulk_permitted_params)
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
        debugger
        @option_types = @product.option_types.includes(:option_values)
      end

      def bulk_permitted_params
        params.require(:variant).permit!
      end

      def collection_actions
        super + [:bulk_update]
      end
    end
  end
end
