# INSTALL

## Dependencies
Install Neo4j: brew install michael-simons/homebrew-seabolt/seabolt

Java SDK 8: https://www.oracle.com/mx/java/technologies/javase/javase-jdk8-downloads.html

## Bundle

bundle install

## Create and configure databases

### Development

By default, the http service is on :7474 and the "bolt" protocol is on :7473

```
bundle exec rake "neo4j:install[community-latest,development]"
```

### Test

Configure the http on 7475 and this will configure "bolt" protocol on :7472

```
bundle exec rake "neo4j:install[community-latest,test]"
bundle exec rake "neo4j:config[test,7475]"
```

### Database dependencies

Add the plugin apoc (already checked in):

cp db/neo4j/apoc-3.4.0.8-all.jar db/neo4j/development/plugins/
cp db/neo4j/apoc-3.4.0.8-all.jar db/neo4j/test/plugins/

### Start and migrate

bundle exec rake 'neo4j:start[development]'
bundle exec rake 'neo4j:start[test]'

rake neo4j:migrate

## Done

You should be able to run the specs:

bundle exec rspec ./spec/models/expert_spec.rb
