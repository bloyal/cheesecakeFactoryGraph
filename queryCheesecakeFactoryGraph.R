#queryCheesecakeFactoryGraph.R
library(RNeo4j);

graph = startGraph("http://localhost:7474/db/data/");

beerNode <- getLabeledNodes(graph, "MenuItem", name = "Beer");

beerRels <- sapply(beerNode, outgoingRels);

wineFeatures <- getFeaturesForMenuItem(graph, "Wine");

wineConnections <- getRelatedMenuItems(graph, "Wine");

getFeaturesForMenuItem <- function(graph, itemName){
  query <- "MATCH (a:MenuItem {name:{name}})-[r:HAS_FEATURE]->(b:Feature)
            RETURN DISTINCT b.name
            ORDER BY b.name";
  results<-cypher(graph, query, name=itemName);  
  names(results)<-c("features");
  results;
}

getRelatedMenuItems <- function(graph, itemName){
  query <- "MATCH (a:MenuItem {name:{name}})-->(b:Feature)<--(c:MenuItem)
            RETURN DISTINCT c.name
            ORDER BY c.name";
  results<-cypher(graph, query, name=itemName);  
  names(results)<-c("relatedMenuItems");
  results;
}
