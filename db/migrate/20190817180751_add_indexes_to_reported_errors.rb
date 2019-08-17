class AddIndexesToReportedErrors < ActiveRecord::Migration[5.2]
  def change
    add_index :reported_errors, :source
    add_index :reported_errors, :priority
  end
end
