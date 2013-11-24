class AddBscSpecToVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :bsc_spec, :string, :before => :weight
  end
end
