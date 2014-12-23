#queryCheesecakeFactoryGraph.R
library(RNeo4j);

graph = startGraph("http://localhost:7474/db/data/");

getMenuItemNode <- function(graph, itemName){
  getLabeledNodes(graph, "MenuItem", name = itemName);
}

getFeatureNode <- function(graph, featureName){
  getLabeledNodes(graph, "Feature", name = featureName);
}

getMaxSessionId <- function(graph){
  query <- "MATCH (n:Session) RETURN MAX(n.id) as max_id"
  results<-as.integer(cypher(graph, query));  
}

createSession <- function(graph){
  node <- createNode(graph, "Session", id = getMaxSessionId(graph)+1)
}

getFeatureNamesForMenuItem <- function(graph, itemName){
  query <- "MATCH (a:MenuItem {name:{name}})-[r:HAS_FEATURE]->(b:Feature)
            RETURN DISTINCT b.name
            ORDER BY b.name";
  results<-cypher(graph, query, name=itemName);  
  names(results)<-c("name");
  results;
}

getRandomMenuItemNames <- function(graph, maxItems=1){
  query <- paste("MATCH (a:MenuItem) 
            WITH a, rand() as r 
            RETURN a.name
            ORDER BY r 
            LIMIT ", maxItems, sep="");
  results<-cypher(graph, query);  
  names(results)<-c("name");
  results;
}

getAllRelatedMenuItemNames <- function(graph, itemName){
  query <- "MATCH (a:MenuItem {name:{name}})-->(b:Feature)<--(c:MenuItem)
            RETURN DISTINCT c.name
            ORDER BY c.name";
  results<-cypher(graph, query, name=itemName);  
  names(results)<-c("name");
  results;
}

getSomeRelatedMenuItemNames <- function(graph, itemName, maxItems = 2) {
  query <- paste("MATCH (a:MenuItem {name:{name}})-->(b:Feature)<--(c:MenuItem)
            WITH DISTINCT c 
            WITH c, rand() as r 
            RETURN c.name 
            ORDER BY r 
            LIMIT ", maxItems, sep="")
  results<-cypher(graph, query, name=itemName);  
  names(results)<-c("name");
  results;
}

#Get features of menu item 1 that are NOT in menu item 2
getMenuItemDifference <- function(graph, name1, name2){
  features1 <- getFeatureNamesForMenuItem(graph, name1);
  features2 <- getFeatureNamesForMenuItem(graph, name2);
  '%nin%' <- Negate('%in%');
  features1$name[features1$name %nin% features2$name];
}

#Need function here to create relationship between session and unchosen 
#features nodes, with property of -1 each time it is chosen against

#Initialize on 2 random menu items
options<-getRandomMenuItemNames(graph,2);

for (i in 1:10) {
  #Select between 2 menu items
  choice<-options[readline(paste("Please select either (1) ",options[1,], 
                                  " or (2) ", options[2,], ": ", sep="")),];
  print(paste("Choice is ",choice, sep=""));
  nonChoice<-options[options!=choice];
  print(paste("Choice is not ",nonChoice, sep=""));
  nonChosenFeatures<-getMenuItemDifference(graph, nonChoice, choice);
  print(nonChosenFeatures);
  options<-getSomeRelatedMenuItemNames(graph, choice, 2);
}