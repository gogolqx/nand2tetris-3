require "vm_translator/version"

require 'vm/instruction'

module VmTranslator
  def self.translate(bytecode)
    assemblies = bytecode.lines.map do |line|
      VM::Instruction.build_for(line.chomp).commented_assemblies
    end
    assemblies.flatten!
    assemblies.compact!
    assemblies.join("\n") + "\n"
  end
end
