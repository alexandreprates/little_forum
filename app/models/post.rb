class Post < ActiveRecord::Base
  # Metodo virtual para receber a id do post "pai" criando assim
  # uma estrutura encadeada. Quando não setado o post é considerado
  # como um topico
  attr_accessor :parent_id
  attr_accessible :content, :parent_id
  
  before_create :make_path
  before_destroy :remove_children
  
  validates :content, :presence => true
  
  # trazendo os registros ordenados por arvore por padrao
  default_scope order(:path)

  # Listando somente os topicos
  scope :topics, where(:topic => true)
  
  # Metodo auxiliar para recuperar de forma rapida todas as
  # replicas de um determinado post.
  def replies
    self.class.where('id != ? AND path like ?', self.id, "#{self.path}%")
  end
  
  private
  
  # O path eh usado para a ordenacao dos registros em forma de arvore
  # para determinar qual o nivel do elemento eh utilizado o atributo
  # *parent_id*.
  # Quando o *parent_id* nao vem como nil o registro eh considerado como
  # um topico
  def make_path
    unless self.parent_id
      make_path_for_topic
    else
      make_path_for_reply!
    end
  end
  
  # Estou separando as regras de criacao para facilitar a leitura e
  # manutencao
  # 
  # Cria o path de post de primeiro nivel ou topicos
  def make_path_for_topic
    current_max_path = self.class.topics.maximum(:path) || '0.'
    self.path = current_max_path.next
    self.topic = true
  end
  
  # Estou separando as regras de criacao para facilitar a leitura e
  # manutencao
  # 
  # Cria o path de posts vinculados a outro elemento, observe que este
  # metodo possui um ! no final, isso porque ele altera a contagem de 
  # filhos *children* do registro pai
  def make_path_for_reply!
    parent = self.class.find(self.parent_id)
    parent.increment!(:children)
    self.path = parent.path + "#{parent.children}."
  end

  # remove os posts viculados ao post que sera removido
  def remove_children
    self.replies.collect &:destroy
  end
  
end
