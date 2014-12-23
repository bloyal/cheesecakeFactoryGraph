#buildCheesecakeFactoryGraph.R

#Uses Rneo4j package to build a Neo4j graph database of the Cheesecake Factory
#menu.

source("~/GitHub/cheesecakeFactoryGraph/scrape_ckf.R");
source("~/GitHub/cheesecakeFactoryGraph/build_ckf_graph.R");

menu <- getMenuItems("http://www.thecheesecakefactory.com/menu");
features <- getFeatures(menu);

graph = startGraph("http://localhost:7474/db/data/");
clear(graph, input=FALSE);

bulkCreateNodes(graph, "MenuItem","name",menu$name);
bulkCreateNodes(graph, "Feature","name",unique(features$feature));

bulkUpdateNodeProperties(graph, rep("MenuItem",323), 
                         rep("name",323), menu$name, 
                         rep("description",323), menu$description);

bulkCreateRelationships(graph, 
                         rep("MenuItem",3184), rep("name",3184), features$item,
                         rep("Feature",3184), rep("name",3184), features$feature,
                         rep("HAS_FEATURE",3184));