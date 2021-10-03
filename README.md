# neo4j-cyhper-demo-01
This is the Neo4j demo that I give to demonstrate some of the unique characteristics of graph databases. *I'm just roughing this in for now. I'll clean it up later (right).*

Rough outline of steps:

 - **Setup a test Neo4j database.** Outside the scope of this demo, but I find that the free version of Neo4j Desktop works just fine. You can download Neo4j desktop for free here: [https://neo4j.com/download/](https://neo4j.com/download/)
 - Create source nodes in neo4j for person1 (Al).
 - Create a "golden" record that connects the source nodes for person1. It will look like this:

![Screen Shot 2021-10-03 at 11 09 13 AM](https://user-images.githubusercontent.com/11652957/135764383-9850db1e-9aad-47ec-83c3-9c9bb961f9f3.png)
 - Create person2 Record (Alisha)
 - Connect person2 to a fund
 - Connect person2's social media to person1. It will look like this:

![Screen Shot 2021-10-03 at 11 16 42 AM](https://user-images.githubusercontent.com/11652957/135764646-fb2a1e57-2fca-458e-9eca-0464630f79d2.png)
 - Create a person3 Record (Bob). 
 - Query all the records. The graph will now look like this:

![Screen Shot 2021-10-03 at 11 27 26 AM](https://user-images.githubusercontent.com/11652957/135764883-755a9328-d8a8-43d0-bb9e-ca18dd47f41b.png)
 - We can now query for the shortest path of relationships between person3 (Bob) and person2 (Alisha) with this code:
 - 
        MATCH path = (p1:persona {name:"Robert Smith"})-[*]-(p2:persona {name:"Alisha Alisha"})
        RETURN path
        ORDER BY LENGTH(path) LIMIT 1
 ![Screen Shot 2021-10-03 at 11 30 40 AM](https://user-images.githubusercontent.com/11652957/135765019-d33c0106-ca33-408d-b1a8-77ce811797e9.png)

 - We can query for **ALL** paths of relationships by removing the ORDER BY statement from the query above:
 - 
        MATCH path = (p1:persona {name:"Robert Smith"})-[*]-(p2:persona {name:"Alisha Alisha"})
        RETURN path
![Screen Shot 2021-10-03 at 11 36 34 AM](https://user-images.githubusercontent.com/11652957/135765157-50c059e4-15c9-4cea-9ed5-39a5cff6ce88.png)

 - **FINAL STEP: Perform demo. Amaze friends and coworkers by asking them to replicate the demo in an RDBMS using SQL.**

