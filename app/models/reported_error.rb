class ReportedError < ApplicationRecord



  def self.report(source, errs, priority)
    err = ReportedError.new

    err.source = source
    err.errs = errs
    err.priority = priority

    if !err.save
      puts "THIS IS FINE!!!!!!!!!!!!!!!"
    end
  end


end
