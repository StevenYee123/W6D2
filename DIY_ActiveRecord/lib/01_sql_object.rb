require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @cols if @cols

    return_arr = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      SQL

    @cols = return_arr.first.map { |ele| ele.to_sym}

  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) do 
        attributes[col.to_sym]
      end
    end

    self.columns.each do |col|
      define_method(col.to_s + "=") do |val|
        attributes[col.to_sym] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    # @table_name ||= self.name.underscore.pluralize
    @table_name ||= name.tableize
  end

  def self.all
    arr = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.class.table_name}
    SQL
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |k, v|
      sym = k.to_sym
      unless self.class.columns.include?(sym)
        raise "unknown attribute '#{k}'"

      else
        self.send((k.to_s + "=").to_sym, v)
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
