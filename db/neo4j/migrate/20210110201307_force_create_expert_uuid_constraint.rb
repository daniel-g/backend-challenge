class ForceCreateExpertUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :Expert, :uuid, force: true
  end

  def down
    drop_constraint :Expert, :uuid
  end
end
