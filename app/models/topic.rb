class Topic
  include ActiveGraph::Node
  property :title

  validates :title, presence: true

  has_one :in, :expert, type: false, model_class: :Expert
end
