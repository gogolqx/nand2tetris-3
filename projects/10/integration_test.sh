#!/usr/bin/env ruby
# vi:syntax=ruby
require 'pathname'
require 'tempfile'

ROOT = Pathname.new(File.absolute_path(__FILE__)).dirname
MIX_PATH = ROOT + "jc"

def compare_files(generated_file, canonical_file)
  output = `TextComparer.sh #{canonical_file} #{generated_file}`
  if $?.success?
    puts "[SUCCESS] #{canonical_file}"
  else
    puts "[FAILED] #{canonical_file}"
    puts output
  end
end

def canonical_token_file(jack_file)
  jack_file.dirname + (jack_file.basename(".jack").to_s + "T.xml")
end

def parse(jack_file)
  tmp = Tempfile.new("tokenized")
  `cd #{MIX_PATH} && mix parse #{jack_file} > #{tmp.path}`
  fail "Failed to parse #{jack_file}" unless $?.success?
  tmp
end

def tokenize(jack_file)
  tmp = Tempfile.new("tokenized")
  `cd #{MIX_PATH} && mix tokenize #{jack_file} > #{tmp.path}`
  fail "Failed to tokenize #{jack_file}" unless $?.success?
  tmp
end

#Tokenizer Tests
canonical_token_files = Dir[ROOT+"*/*T.xml"]
canonical_token_files.each do |canonical_file|
  jack_file = canonical_file[0..-6]+".jack"
  tmp = tokenize(jack_file)
  compare_files(tmp.path, canonical_file)
end

#Expressionless Parser Tests
canonical_files = Dir[ROOT+"ExpressionlessSquare/*.xml"].reject{|p| p.include?("T.xml")}
canonical_files.each do |canonical_file|
  jack_file = canonical_file[0..-4]+"jack"
  tmp = parse(jack_file)
  compare_files(tmp.path, canonical_file)
end

#Square Parser Tests
canonical_files = Dir[ROOT+"Square/*.xml"].reject{|p| p.include?("T.xml")}
canonical_files.each do |canonical_file|
  jack_file = canonical_file[0..-4]+"jack"
  tmp = parse(jack_file)
  compare_files(tmp.path, canonical_file)
end

#ArrayTest Parser Tests
canonical_files = Dir[ROOT+"ArrayTest/*.xml"].reject{|p| p.include?("T.xml")}
canonical_files.each do |canonical_file|
  jack_file = canonical_file[0..-4]+"jack"
  tmp = parse(jack_file)
  compare_files(tmp.path, canonical_file)
end
