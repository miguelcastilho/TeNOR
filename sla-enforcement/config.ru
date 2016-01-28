#\ -p 4568

root = ::File.dirname(__FILE__)
require ::File.join(root, 'main')

run OrchestratorSlaEnforcement.new
