require 'vm/instruction/add'
require 'vm/instruction/and'
require 'vm/instruction/eq'
require 'vm/instruction/gt'
require 'vm/instruction/lt'
require 'vm/instruction/neg'
require 'vm/instruction/not'
require 'vm/instruction/no_op'
require 'vm/instruction/or'
require 'vm/instruction/push_constant'
require 'vm/instruction/sub'

module VM
  module Instruction
    def self.build_for(line)
      line = strip_comment(line)
      if line.empty?
        NoOp.new
      else
        klass = line.split[0..1].map{|w| w.capitalize}.join
        klass = const_get(klass)
        klass.new(line)
      end
    end

    def self.strip_comment(line)
      if idx = line.index("//")
        line = line.slice(0,idx)
      end
      line
    end
  end
end
