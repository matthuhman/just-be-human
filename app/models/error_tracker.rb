class ReportedError < ApplicationRecord



  def self.log_save_error(source, errors)
    err = ReportedError.new

    err.source = source
    err.errors = errors

    if !err.save
      puts "THIS IS FINE!!!!!!!!!!!!!!!"
    end
  end


end