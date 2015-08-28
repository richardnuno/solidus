class MigrateProductPropertiesToVariantProperties < ActiveRecord::Migration
  disable_ddl_transaction!

  def up
    Rake::Task["spree:migrations:migrate_variant_properties:up"].invoke
  end

  def down
    Rake::Task["spree:migrations:migrate_variant_properties:down"].invoke
  end
end
