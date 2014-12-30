#get high scoring options related to a node

getHighScoringOptions <- function(graph, session, itemName, maxItems = 2){
  #print(paste("Item Name is ",itemName,sep=""))
  query <- paste("MATCH (a:MenuItem {name:{name}})-->(f:Feature)<--(c:MenuItem),
    (s:Session {id:", session$id, "})-[r:HAS_AFFINITY_FOR]->(f)
    WITH a.name as choice_name, c.name as related_item_name, sum(r.score) as affinity_score
    WITH choice_name, related_item_name, affinity_score, rand() as random
    RETURN related_item_name
    ORDER BY choice_name, affinity_score DESC, random
    LIMIT ", maxItems, sep="");
  
  #print(query)
  results<-cypher(graph, query, name=itemName);  
  names(results)<-c("name");
  results;
}

#---start here
#This is an interesting query - will probably need something like this to normalize affinities
# MATCH (f:Feature)<-[r2:HAS_FEATURE]-(c:MenuItem),
# (s:Session {id:1})-[r:HAS_AFFINITY_FOR]->(f:Feature)
# RETURN c.name as item_name, c.description, sum(r2.strength) as feature_strength, sum(r.score) as affinity_score
# ORDER BY affinity_score desc, c.name


#get affinity scores
# match (s:Session {id:8})-[r:HAS_AFFINITY_FOR]->(f:Feature)
# return s.id as session_id, r.score as affinity_score, f.name as feature_name
# order by r.score desc

#Get list of menu items, ranked by affinity score:
# MATCH (f:Feature)<--(c:MenuItem),
# (s:Session {id:1})-[r:HAS_AFFINITY_FOR]->(f:Feature)
# RETURN c.name as item_name, c.description, sum(r.score) as affinity_score
# ORDER BY affinity_score desc, c.name

#Get related menu items
# MATCH (a:MenuItem {name:"Lemon Drop"})-->(b:Feature)<--(c:MenuItem)
# RETURN DISTINCT a.name, b.name, c.name
# ORDER BY c.name

#Get related menu items, ordered by sum of affinity scores
# MATCH (a:MenuItem {name:"Lemon Drop"})-->(f:Feature)<--(c:MenuItem),
# (s:Session {id:12})-[r:HAS_AFFINITY_FOR]->(f)
# RETURN a.name as choice_name, c.name as related_item_name, sum(r.score) as affinity_score
# ORDER BY a.name, affinity_score desc