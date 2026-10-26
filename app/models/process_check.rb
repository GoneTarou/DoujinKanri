class ProcessCheck < ApplicationRecord
  belongs_to :production_unit
  belongs_to :work_process
end
