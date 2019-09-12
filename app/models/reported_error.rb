class ReportedError < ApplicationRecord



  def self.report(source, errors, priority)
    err = ReportedError.new

    err.source = source
    err.errors = errors
    err.priority = priority

    if !err.save
      puts "THIS IS FINE!!!!!!!!!!!!!!!"
    end
  end


end
