class RenameErrorsInReportedError < ActiveRecord::Migration[6.0]
  def change

    rename_column :reported_errors, :errors, :errs
  end
end
