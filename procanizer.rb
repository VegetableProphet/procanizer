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

class A
  extend Procanizer
  
  def pub1
    puts "pub1!"
  end

  def pub2
    puts "pub1!"
  end
  add_proc_for :pub1, :pub2

  private

  with_proc def priv
    puts "priv!"  
  end

  protected

  with_proc def prot
    puts "prot!"
  end
end

class B
  extend Procanizer

  with_proc def pub_b
    puts "pub_b"
  end
end

# A

puts "A.public_instance_methods:"
puts A.public_instance_methods(false).join(" | ")

puts "A.private_instance_methods:"
puts A.private_instance_methods(false).join(" | ")

puts "A.protected_instance_methods:"
puts A.protected_instance_methods(false).join(" | ")

puts "A.procanized_instance_methods:"
puts A.procanized_instance_methods.to_s

A.new.pub1_proc
puts A.procanized_instance_methods.to_s

A.new.send(:priv_proc)
puts A.procanized_instance_methods.to_s

A.new.send(:priv_proc)
puts A.procanized_instance_methods.to_s

# B

puts "B.public_instance_methods:"
puts B.public_instance_methods(false).join(" | ")

puts "B.procanized_instance_methods:"
puts B.procanized_instance_methods.to_s

B.new.pub_b_proc
puts B.procanized_instance_methods.to_s

# CHAINING EXAMPLE

module SomeMethods
  def increment(arr)
    arr.map { |i| i + 1 }
  end

  def stringify(arr)
    arr.map { |i| i.to_s }
  end

  def capitalize(arr)
    arr.map { |i| i.capitalize }
  end
end


class SuperService
  extend Procanizer
  include SomeMethods

  add_proc_for :increment, :stringify, :capitalize

  def initialize
    @final = []
  end

  def call
    [[1, 2], [3, 4], [5, 6]].each(
      &increment_proc >> stringify_proc >> capitalize_proc >> commit_proc
    )

    puts @final.join(":")
  end

  with_proc def commit(arr)
    @final += arr.map { |i| "#{i} commited!" }
  end
end