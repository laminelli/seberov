class AddApartmentsApartmentsFloorsCloakrooms < ActiveRecord::Migration

  def change
    add_column :refinery_apartment_floors, :cloakroom1_area, :float
    add_column :refinery_apartment_floors, :cloakroom2_area, :float
  end

end
