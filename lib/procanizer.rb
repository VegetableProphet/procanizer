# frozen_string_literal: true

module Procanizer
  def add_proc_for(*meths)
    meths.each do |meth|
      define_proc_for_instance_method(meth)
      set_proc_privacy_level(meth)
    end
  end

  def define_proc_for_instance_method(meth)
    define_method proc_name(meth) do
      @procanized_instance_methods       ||= {}
      @procanized_instance_methods[meth] ||= method(meth).to_proc
    end
  end

  def set_proc_privacy_level(meth)
    private   proc_name(meth) and return if private_instance_methods.any?(meth)
    protected proc_name(meth) and return if protected_instance_methods.any?(meth)
  end

  def proc_name(meth)
    meth = meth.to_s

    with_bang?(meth) ? "#{meth.chop}_proc!".to_sym : "#{meth}_proc".to_sym
  end

  def with_bang?(meth)
    meth.last == "!"
  end

  alias with_proc add_proc_for
end
