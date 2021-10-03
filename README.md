# neo4j-cyhper-demo-01
This is the Neo4j demo that I give to demonstrate some of the unique characteristics of graph databases. *I'm just roughing this in for now. I'll clean it up later (yeah, right).*

Rough outline of steps:

 - **Setup a test Neo4j database.** Outside the scope of this demo, but I find that the free version of Neo4j Desktop works just fine. You can download Neo4j desktop for free here: [https://neo4j.com/download/](https://neo4j.com/download/)
 - Create three source nodes in neo4j for person1 (Al). You can execute this as one large statement, or in three separate statements. Only the third statement is designed to return results. This represents person data sourced from three separate systems:

        // CREATE A PERSON (person1) IN SYSTEM #1, HR System (HCM)
        // Create HR System (HCM) Source Record for person1 (Al)
        create (AlbertWirtes:persona {name:"Al Wirtes", birthday:"April 1", sourceSystem:"HCM", sourceSystemId:"99008877"})
        create (AlbertHomeAddr:address {add1:"123 Main Street", city:"Mytown", state:"Indiana", zip:"55555"})
        CREATE (AlbertWirtes)-[:ADDRESS {type:"home"}]->(AlbertHomeAddr)
        create (albertEmail:email {email:"al.wirtes@college.edu"})
        CREATE (AlbertWirtes)-[:EMAIL {type:"official"}]->(albertEmail)
        CREATE (albertPhone:phone {mobile:"303-555-2152"})
        CREATE (AlbertWirtes)-[:PHONE {type:"mobile"}]->(albertPhone)
        create (d:department {name:"IT"})
        CREATE (AlbertWirtes)-[:DEPT]->(d)
        
        // CREATE PERSON (person1) IN SYSTEM #2, Student System (CS)
        // Create Student System (CS) Source Record for person1 (Al)
        create (AlWirtes:persona {name:"Albert Wirtes", birthday:"April 1", sourceSystem:"CS", sourceSystemId:"123456"})
        create (AlHomeAddr:address {add1:"123 Main Street", city:"Anytown", state:"Indiana", zip:"46410"})
        CREATE (AlWirtes)-[:ADDRESS {type:"home"}]->(AlHomeAddr)
        create (alEmail:email {email:"al.wirtes@college.edu"})
        CREATE (AlWirtes)-[:EMAIL {type:"official"}]->(alEmail)
        CREATE (alPhone:phone {mobile:"303-555-1212"})
        CREATE (AlWirtes)-[:PHONE {type:"mobile"}]->(alPhone)
        
        // CREATE PERSON (person1) IN SYSTEM #3, Fund Raising CRM (Advance)
        // Create Advance Record for person1 (Al)
        CREATE (adv:persona {name:"Al Wirtes", sourceSystem:"Advance", sourceSystemId:"ADV123"})
        CREATE (advEmail:email {email:"wirtes@gmail.com"})
        CREATE (adv)-[:EMAIL]->(advEmail)
        CREATE (f:fund {name:"College Radio Station"})
        CREATE (adv)-[:FUND]->(f)
        CREATE (t:social {name:"@al_wirtes"})
        CREATE (adv)-[:TWITTER]->(t)
        //
        RETURN AlbertWirtes, AlWirtes, adv

 - The Cypher above will return three nodes:
![Screen Shot 2021-10-03 at 12 39 41 PM](https://user-images.githubusercontent.com/11652957/135767133-0d7f7dbd-5a2f-453f-a681-f853208a8fc0.png)

 - Click the "Table View" icon on the upper left to see more data about each node:
![Screen_Shot_2021-10-03_at_12_40_46_PM](https://user-images.githubusercontent.com/11652957/135767202-72342ae2-8284-47f7-934d-4673f0426b06.png)

 - Click back on the "Graph" icon. And now query everything we just created. This query simply matches all nodes and returns them with a limit of 50:

        MATCH (n) RETURN n LIMIT 50
        
![Screen Shot 2021-10-03 at 12 53 54 PM](https://user-images.githubusercontent.com/11652957/135767561-ffaec88e-da05-4d40-b3f7-5a55f7d27978.png)

 - Now create a "golden" record that connects the source nodes for person1. We're going to do this in two passes for clarity. First, we'll connect the records from HCM and CS to the new golden record:

        // Match CS and HCM records and create a golden record, then create relationships to the source records.
        MATCH (a:persona),(b:persona)
        WHERE a.sourceSystemId = '123456' AND b.sourceSystemId = '99008877' // CS & HCM
        CREATE (g:golden {name:"Al Wirtes", cid:"Golden123"})
        CREATE (a)-[:CS]->(g)
        CREATE (b)-[:HCM]->(g)
        RETURN a, b, g

 - It will look like this:

![Screen Shot 2021-10-03 at 12 56 01 PM](https://user-images.githubusercontent.com/11652957/135767612-ba36e69c-4e1a-439d-b103-5426f8d18f26.png)

- Now let's relate the source data from the third system to to the golden record:

        // Match Advance record and create relationships
        MATCH (g:golden) WHERE g.cid="Golden123"
        MATCH (adv:persona) WHERE adv.sourceSystemId="ADV123"
        CREATE (adv)-[:ADVANCE]->(g)
        
- Query all the nodes again to see what we have

        MATCH (n) RETURN n LIMIT 25

![Screen Shot 2021-10-03 at 11 09 13 AM](https://user-images.githubusercontent.com/11652957/135764383-9850db1e-9aad-47ec-83c3-9c9bb961f9f3.png)

 - Let's create person2 (Alisha). She only has a source record in the student system (CS):

        // Create person2 CS Record
        create (Alisha:persona {name:"Alisha Alisha", birthday:"May 1", sourceSystem:"CS", sourceSystemId:"CS1234"})
        create (addr:address {add1:"555 Sesame Street", city:"Anytown", state:"Colorado", zip:"80321"})
        CREATE (Alisha)-[:ADDRESS {type:"home"}]->(addr)
        create (e:email {email:"alisha.alisha@college.edu"})
        CREATE (Alisha)-[:EMAIL {type:"official"}]->(e)
        CREATE (ph:phone {mobile:"702-555-1212"})
        CREATE (Alisha)-[:PHONE {type:"mobile"}]->(ph)
        CREATE (pr:program {title:"Journalism"})
        CREATE (Alisha)-[:MAJOR {degree:"BA"}]->(pr)
        CREATE (s:social {name: "@alisha_alisha"})
        CREATE (Alisha)-[:TWITTER]->(s)

 - Create a relationship to between person2 and a fund:

        // Run separately
        MATCH (f:fund) WHERE f.name="College Radio Station"
        MATCH (Alisha:persona) WHERE Alisha.sourceSystemId="CS1234"
        CREATE (Alisha)-[:VOLUNTEER]->(f)

 - Person2 also has social media relationships to person1:

        // Create Social Media Relationships between person1 (Al) and person2 (Alisha)
        MATCH (s1:social) WHERE s1.name="@al_wirtes"
        MATCH (s2:social) WHERE s2.name="@alisha_alisha"
        CREATE (s1)-[:FOLLOWS]->(s2)
        CREATE (s2)-[:FOLLOWS]->(s1)

 - Query all the nodes to see the relationships:

        MATCH (n) RETURN n LIMIT 25

![Screen Shot 2021-10-03 at 11 16 42 AM](https://user-images.githubusercontent.com/11652957/135764646-fb2a1e57-2fca-458e-9eca-0464630f79d2.png)

 - Let's create the last record, person3 (Bob)

        // Let's make person3 (Bob)
        // Create HCM Record
        MATCH (d:department {name:"IT"})
        create (Bob:persona {name:"Robert Smith", birthday:"Jan 1", sourceSystem:"HCM", sourceSystemId:"666", preferredName:"Suds"})
        create (BobHomeAddr:address {add1:"123 My Street", city:"Cooperstown", state:"PA", zip:"12345"})
        CREATE (Bob)-[:ADDRESS {type:"home"}]->(BobHomeAddr)
        create (BobEmail:email {email:"robert.smith@college.edu"})
        CREATE (Bob)-[:EMAIL {type:"official"}]->(BobEmail)
        CREATE (BobPhone:phone {mobile:"303-555-4321"})
        CREATE (Bob)-[:PHONE {type:"mobile"}]->(BobPhone)
        CREATE (Bob)-[:DEPT]->(d)

 - Query all the records with `MATCH (n) RETURN n LIMIT 25`. The graph will now look like this:

![Screen Shot 2021-10-03 at 11 27 26 AM](https://user-images.githubusercontent.com/11652957/135764883-755a9328-d8a8-43d0-bb9e-ca18dd47f41b.png)
 - We can now query for the shortest path of relationships between person3 (Bob) and person2 (Alisha) with this code:
 - 
        MATCH path = (p1:persona {name:"Robert Smith"})-[*]-(p2:persona {name:"Alisha Alisha"})
        RETURN path
        ORDER BY LENGTH(path) LIMIT 1
        
 ![Screen Shot 2021-10-03 at 11 30 40 AM](https://user-images.githubusercontent.com/11652957/135765019-d33c0106-ca33-408d-b1a8-77ce811797e9.png)

 - We can query for **ALL** paths of relationships by removing the ORDER BY statement from the query above:
 
        MATCH path = (p1:persona {name:"Robert Smith"})-[*]-(p2:persona {name:"Alisha Alisha"})
        RETURN path
        
![Screen Shot 2021-10-03 at 11 36 34 AM](https://user-images.githubusercontent.com/11652957/135765157-50c059e4-15c9-4cea-9ed5-39a5cff6ce88.png)

 - **FINAL STEP: Perform demo. Amaze friends and coworkers by asking them to replicate the demo in a RDBMS using SQL, and they'll be like:**

    ![Sudden-Clarity-Clarence](https://user-images.githubusercontent.com/11652957/135769271-29526ca5-5d0d-49b8-99ec-22ef9c459e12.jpg)
