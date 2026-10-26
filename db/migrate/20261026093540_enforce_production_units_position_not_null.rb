class EnforceProductionUnitsPositionNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :production_units, :position, false
  end
end
