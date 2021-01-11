class Expert
  include ActiveGraph::Node
  property :name
  property :website

  validates :name, :website, presence: true

  has_many :both, :friends, type: :friend_of, model_class: :Expert
  has_many :out, :topics, type: :writes_about, model_class: :Topic

  def search(q)
    # uniqueness: "NODE_RECENT"
    # uniqueness among the most recent visited node
    # hence the shorter path between the last leave and the first node.
    result = ActiveGraph::Base.query('
      MATCH (e:Expert)
      WHERE (e.uuid = $uuid)
      MATCH (e)-[:friend_of]-(friend:Expert)
      WITH e, collect(ID(friend)) AS first_level_ids
      MATCH (e)-[:friend_of*2]-(other_friend:Expert)
      WHERE NOT(ID(other_friend) IN first_level_ids)
      MATCH (other_friend)-[:writes_about]->(topic:Topic)
      WHERE (topic.title STARTS WITH $query)
      CALL apoc.path.expandConfig(other_friend, {
        relationshipFilter: "friend_of",
        minLevel: 1,
        maxLevel: 5,
        terminatorNodes: [e],
        uniqueness: "NODE_RECENT"
      }) YIELD path
      RETURN other_friend, topic, path
    ', uuid: uuid, query: q)

    result.map do |row|
      {
        expert: row.values[0],
        topic: row.values[1],
        path: row.values[2].map { |path| path.start_node.properties[:name] }.reverse,
      }
    end
  end
end
