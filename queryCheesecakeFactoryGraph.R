#queryCheesecakeFactoryGraph.R
library(RNeo4j);

graph = startGraph("http://localhost:7474/db/data/");

beerNode <- getLabeledNodes(graph, "MenuItem", name = "Beer");

beerRels <- sapply(beerNode, outgoingRels);

wineConnections <- getRelatedMenuItems(graph, "Wine");

getRelatedMenuItems <- function(graph, itemName){
  query <- "MATCH (a:MenuItem {name:{name}})-->(b:Feature)<--(c:MenuItem)
            RETURN DISTINCT c.name
            ORDER BY c.name";
  results<-cypher(graph, query, name=itemName);  
  names(results)<-c("relatedMenuItems");
  results;
}
