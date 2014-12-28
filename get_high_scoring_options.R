#get high scoring options related to a node

getHighScoringOptions <- function(graph, session, itemName, maxItems = 2){
  print(maxItems)
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