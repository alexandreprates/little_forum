# encoding: UTF-8
require 'yaml'

class Censor
  CHAR_VARIANTS = {'a' => '[aáâãà$@4]', 'e' => '[eéêè3]', 'i' => '[iíîì1|]', 'o' => '[oóôõò0º]', 'u' => '[uúûù]', 'c' => '[cç]'}.freeze
  FORBIDDEN_WORLDS_SOURCE = 'config/forbidden_worlds.yml'.freeze

  attr_accessor :forbidden_worlds
  attr_reader :filter
  
  def initialize(options = {})
    self.forbidden_worlds = options[:forbidden_worlds] || load_forbidden_list
  end
  
  def forbidden_worlds=(values)
    values.tap do |values_array|
      @forbidden_worlds = values_array
      build_filter
    end
  end
  
  def before_save(record)
    record.content = sanitize(record.content)
  end
  
  def build_filter
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
    pre_filter = @forbidden_worlds.collect { |world| include_char_variants Regexp.escape(world) } * "|"
    /\b(#{pre_filter})\b/im
  end
  
  def include_char_variants(world)
    keys = CHAR_VARIANTS.keys.join
    world.downcase.gsub(/[#{keys}]/, CHAR_VARIANTS)
  end
  
end