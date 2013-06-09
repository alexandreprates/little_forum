# encoding: UTF-8
require 'yaml'

class Censor
  CHAR_VARIANTS = {'a' => '[aáâãà$@4]', 'e' => '[eéêè3]', 'i' => '[iíîì1|]', 'o' => '[oóôõò0º]', 'u' => '[uúûù]', 'c' => '[cç]'}.freeze
  FORBIDDEN_WORLDS_SOURCE = 'config/forbidden_worlds.yml'.freeze
  
  attr_reader :worlds, :filter
  
  def initialize
    build_filter
  end
  
  def before_save(record)
  end
  
  def build_filter
    @worlds = load_forbidden_list
    @filter = worlds_to_regexp
  end

  def sanitize(text)
    text.gsub(@filter) { |gotcha| 'x' * gotcha.length }
  end

  private
  
  def load_forbidden_list
    raise MissingSourceFile, "can't find world list in '#{FORBIDDEN_WORLDS_SOURCE}'", caller unless File.exist? FORBIDDEN_WORLDS_SOURCE
    YAML.load_file FORBIDDEN_WORLDS_SOURCE
  end
  
  def worlds_to_regexp
    pre_filter = @worlds.collect { |world| include_char_variants Regexp.escape(world) } * "|"
    /\b(#{pre_filter})\b/im
  end
  
  def include_char_variants(world)
    keys = CHAR_VARIANTS.keys.join
    world.downcase.gsub(/[#{keys}]/, CHAR_VARIANTS)
  end
  
end