require "procanizer/version"

module Procanizer
  def self.extended(base)
    base.class_variable_set(:@@procanized_instance_methods, {})
  end

  def procanized_instance_methods
    class_variable_get(:@@procanized_instance_methods)
  end

  def add_proc_for(*meths)
    meths.each do |meth|
      define_proc_for_instance_method(meth)
      set_proc_privacy_level(meth)
    end
  end

  def define_proc_for_instance_method(meth)
    define_method proc_name(meth) do
      (self.class.procanized_instance_methods[meth] ||= method(meth)).to_proc
    end
  end

  def set_proc_privacy_level(meth)
    private   proc_name(meth) and return if private_instance_methods.any?(meth)
    protected proc_name(meth) and return if protected_instance_methods.any?(meth)
  end

  def proc_name(meth)
    "#{meth}_proc".to_sym
  end

  alias_method :with_proc, :add_proc_for
end
