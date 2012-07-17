#!/usr/bin/env ruby

require 'rubygems'
require 'date'
require 'thread'
require 'open4'

Dir.chdir(File.dirname(__FILE__))

$loaded_facter
def num_cpus
  require 'facter'
  $loaded_facter = true
  Facter.loadfacts
  (Facter.value('processorcount') ||
   Facter.value('sp_number_processors') ||
   "1").to_i
end

def clean_hpc
  system('mkdir -p dist/hpc')
  system('rm dist/hpc/* 2> /dev/null')
  system('rm *.tix 2> /dev/null')
  system('rm -r .hpc 2> /dev/null')
end

def clean
  clean_hpc
  system('rm -r dist')
end

def build_cabal
  system('cabal configure')
  raise "cabal configure failed!" unless $?.success?
  system('cabal build')
  raise "cabal build failed!" unless $?.success?
end

def build
  build_cabal
end

def install
  build
  system('cabal install')
  system('cd src ; hastec --libinstall -package-name templhs -I./include Dom.Templ')
end

def hlint
  system('mkdir -p dist')
  system('hlint src --report=dist/hlint.html')
end

def test
  clean
  install
  system('mkdir -p dist/hpc')
  system("./dist/build/templhs-tests/templhs-tests +RTS -N#{num_cpus}")
  raise "tests failed!" unless $?.success?
  system('hpc report templhs-tests.tix')
  system('hpc report templhs-tests > dist/hpc/report.txt')
  system('hpc markup templhs-tests --destdir=dist/hpc >> /dev/null')
  puts('Coverage data stored in dist/hpc')
  puts('Point your browser at file://' + `pwd`.strip + '/dist/hpc/hpc_index.html')
end

def build_examples
  Dir.glob("examples/*/build.sh") do |f|
    system(f)
    raise "example #{f} failed to build!" unless $?.success?
  end
end

def integration_test
  clean
  install
  build_examples
  # todo: run test
end

start = DateTime.now
runcount = 0
ARGV.each do |x|
  self.send(x.to_sym)
  runcount += 1
end
if runcount <= 0
  puts "Usage:   ./maker.rb [action1] [[action2]...]"
  puts "Example: ./maker.rb test"
else
  puts("started: #{start.to_s} finished: #{DateTime.now.to_s}")
end

