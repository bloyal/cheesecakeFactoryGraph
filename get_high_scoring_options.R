#get high scoring options related to a node

getHighScoringOptions <- function(graph, session, itemName, maxItems = 2){
#   query <- paste("MATCH (a:MenuItem {name:{name}})-->(b:Feature)<--(c:MenuItem)
#             WITH DISTINCT c 
#             WITH c, rand() as r 
#             RETURN c.name 
#             ORDER BY r 
#             LIMIT ", maxItems, sep="")
  query <- paste("MATCH (a:MenuItem {name:{name}})-->(f:Feature)<--(c:MenuItem),
            (s:Session {id:12})-[r:HAS_AFFINITY_FOR]->(f)
            RETURN a.name as choice_name, c.name as related_item_name, sum(r.score) as affinity_score
            ORDER BY a.name, affinity_score desc
            LIMIT ", maxItems, sep="");
  print(query)
  results<-cypher(graph, query, name=itemName);  
  names(results)<-c("name");
  results;
}

#get affinity scores
# match (s:Session {id:12})-[r:HAS_AFFINITY_FOR]->(f:Feature),
# (s)-[r2:MADE_CHOICE]->(m:MenuItem)
# return s.id as session_id, r.score as affinity_score, f.name as feature_name, count(r2) as choice_count
# order by r.score desc

#Get related menu items
# MATCH (a:MenuItem {name:"Lemon Drop"})-->(b:Feature)<--(c:MenuItem)
# RETURN DISTINCT a.name, b.name, c.name
# ORDER BY c.name

#Get related menu items, ordered by sum of affinity scores
# MATCH (a:MenuItem {name:"Lemon Drop"})-->(f:Feature)<--(c:MenuItem),
# (s:Session {id:12})-[r:HAS_AFFINITY_FOR]->(f)
# RETURN a.name as choice_name, c.name as related_item_name, sum(r.score) as affinity_score
# ORDER BY a.name, affinity_score desc