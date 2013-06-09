# encoding: UTF-8
require 'yaml'

class Censor
  CHAR_VARIANTS = {'a' => '[aáâãà$@4]', 'e' => '[eéêè3]', 'i' => '[iíîì1|]', 'o' => '[oóôõò0º]', 'u' => '[uúûù]', 'c' => '[cç]'}.freeze
  FORBIDDEN_WORLDS_SOURCE = 'config/forbidden_worlds.yml'.freeze

  # Lista de palavras bloqueadas
  attr_accessor :forbidden_worlds
  # Filtro construido com as palavras
  attr_reader :filter
  
  # Cria um objeto do tipo Censor
  # Na inicialização eh possivel passar a lista de palavras bloqueadas
  # caso contrario ele as carrega do arquivo config/forbidden_worlds.yml
  def initialize(options = {})
    self.forbidden_worlds = options[:forbidden_worlds] || load_forbidden_list
  end
  
  # Define a nova lista de palavras bloqueadas
  # Atencao: sempre que a lista é alterada o censo reconstroi automaticamente
  # o seu filtro
  def forbidden_worlds=(values)
    values.tap do |values_array|
      @forbidden_worlds = values_array
      build_filter
    end
  end
  
  # Recebe o callback do modelo no evento *before_save*
  def before_save(record)
    record.content = sanitize(record.content)
  end

  # Subistitui as palavras bloqueadas no texto por xxx
  def sanitize(text)
    text.gsub(@filter) { |gotcha| 'x' * gotcha.length }
  end

  private
  
  # Reconstroi o filtro
  def build_filter
    @filter = worlds_to_regexp
  end

  # Carrega o array de palavras bloqueadas do arquivo
  def load_forbidden_list
    raise MissingSourceFile, "can't find world list in '#{FORBIDDEN_WORLDS_SOURCE}'", caller unless File.exist? FORBIDDEN_WORLDS_SOURCE
    YAML.load_file FORBIDDEN_WORLDS_SOURCE
  end
  
  # Transforma a lista de palavras numa expressão regular
  def worlds_to_regexp
    pre_filter = @forbidden_worlds.collect { |world| include_char_variants Regexp.escape(world) } * "|"
    /\b(#{pre_filter})\b/im
  end
  
  # Gera as possiveis variantes de cada palavra
  def include_char_variants(world)
    keys = CHAR_VARIANTS.keys.join
    world.downcase.gsub(/[#{keys}]/, CHAR_VARIANTS)
  end
  
end