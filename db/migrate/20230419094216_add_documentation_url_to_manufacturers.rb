class AddDocumentationUrlToManufacturers < ActiveRecord::Migration[5.2]
  def change
    add_column :manufacturers, :documentation_url, :string
  end
end
