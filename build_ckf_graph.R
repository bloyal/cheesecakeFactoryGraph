library(RNeo4j);

#graph = startGraph("http://localhost:7474/db/data/");

#graph$version;
# [1] "2.1.6"

#bulkCreateNodes(graph, "MenuItem","name",menu$name)
#bulkCreateNodes(graph, "Feature","name",unique(unlist(features)))

#bulkUpdateNodeProperties(graph, rep("MenuItem",323), 
#                         rep("name",323), menu$name, 
#                         rep("description",323), menu$description)

# bulkCreateRelationships(graph, 
#                          rep("MenuItem",3184), rep("name",3184), df$menuItems,
#                          rep("Feature",3184), rep("name",3184), df$features,
#                          rep("HAS_FEATURE",3184)
#                          )

bulkCreateNodes<-function(graph, labelName, indexName, indexValues){
  query <- paste("CREATE (n:",labelName," {",indexName,":{indexValue}})", sep="");
  t <- newTransaction(graph);
  
  for (i in 1:length(indexValues)){
   value <- indexValues[i];
   if (i==1) {print(query)}
   appendCypher(t, query, indexValue = value);
  }
  
  commit(t);
  
  addIndex(graph, labelName, indexName);
}

bulkUpdateNodeProperties<-function(graph, labelNames, indexNames, indexValues, 
                                   propertyNames, propertyValues){
  nodeInfo <- cbind(labelName=labelNames, indexName=indexNames, 
                    indexValue=as.character(indexValues), 
                    propertyName=propertyNames, 
                    propertyValue=propertyValues);
  t <- newTransaction(graph);
  
  for (i in 1:nrow(nodeInfo)){
    query <- paste("MATCH (n:", nodeInfo[i,"labelName"]," {", nodeInfo[i,"indexName"], ":'", nodeInfo[i,"indexValue"], "'}) ",
                   "SET n.",nodeInfo[i,"propertyName"],"='",nodeInfo[i,"propertyValue"], "'", sep="");
    if (i==1) {print(query)}
    appendCypher(t, query);
  }

  commit(t);
}

bulkCreateRelationships<-function(graph, 
                                  startLabel, startIndexName, startIndexValue, 
                                  endLabel, endIndexName, endIndexValue,
                                  relationshipType){
  relInfo <- cbind(startLabel, startIndexName, startIndexValue,
                   endLabel, endIndexName, endIndexValue,
                   relationshipType);
  t <- newTransaction(graph);
  for (i in 1:nrow(relInfo)){
    query <- paste("MATCH (a:", relInfo[i,"startLabel"]," {", relInfo[i,"startIndexName"], ":'", relInfo[i,"startIndexValue"], "'}) ",
                   "MATCH (b:", relInfo[i,"endLabel"]," {", relInfo[i,"endIndexName"], ":'", relInfo[i,"endIndexValue"], "'}) ",
                   "CREATE (a)-[r:",relInfo[i,"relationshipType"],"]->(b)", sep="");
    if (i==1) {print(query)}
    appendCypher(t, query);
  }
  commit(t);
}