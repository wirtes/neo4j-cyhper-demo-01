// DEMO
// person1 (Al) Section
// Create CS Record for person1
create (AlWirtes:persona {name:"Albert Wirtes", birthday:"April 24", sourceSystem:"CS", sourceSystemId:"123456"})
create (AlHomeAddr:address {add1:"123 Main Street", city:"Anytown", state:"Indiana", zip:"46410"})
CREATE (AlWirtes)-[:ADDRESS {type:"home"}]->(AlHomeAddr)
create (alEmail:email {email:"al.wirtes@cu.edu"})
CREATE (AlWirtes)-[:EMAIL {type:"official"}]->(alEmail)
CREATE (alPhone:phone {mobile:"303-555-1212"})
CREATE (AlWirtes)-[:PHONE {type:"mobile"}]->(alPhone)

// Create HCM Record for person1
// MATCH (p:persona {sourceSystemId:"99008877"})
create (AlbertWirtes:persona {name:"Al Wirtes", birthday:"April 1", sourceSystem:"HCM", sourceSystemId:"99008877"})
create (AlbertHomeAddr:address {add1:"123 Main Street", city:"Mytown", state:"Indiana", zip:"55555"})
CREATE (AlbertWirtes)-[:ADDRESS {type:"home"}]->(AlbertHomeAddr)
create (albertEmail:email {email:"al.wirtes@college.edu"})
CREATE (AlbertWirtes)-[:EMAIL {type:"official"}]->(albertEmail)
CREATE (albertPhone:phone {mobile:"303-555-2152"})
CREATE (AlbertWirtes)-[:PHONE {type:"mobile"}]->(albertPhone)
create (d:department {name:"IT"})
CREATE (AlbertWirtes)-[:DEPT]->(d)

// Create Advancement Record for person1
CREATE (adv:persona {name:"Al Wirtes", sourceSystem:"Advance", sourceSystemId:"ADV123"})
CREATE (advEmail:email {email:"wirtes@gmail.com"})
CREATE (adv)-[:EMAIL]->(advEmail)
CREATE (f:fund {name:"Radio 1190"})
CREATE (adv)-[:FUND]->(f)
CREATE (t:social {name:"@al_wirtes"})
CREATE (adv)-[:TWITTER]->(t)
//
RETURN AlbertWirtes, AlWirtes, adv



### Create Golden Record for person1

// Match CS and HCM records and create a golden record, then create relationships to the source records.
MATCH (a:persona),(b:persona)
WHERE a.sourceSystemId = '123456' AND b.sourceSystemId = '99008877' // CS & HCM
CREATE (g:golden {name:"Al Wirtes", cid:"Golden123"})
CREATE (a)-[:CS]->(g)
CREATE (b)-[:HCM]->(g)
RETURN a, b, g

// Match Advance record and create relationships
MATCH (g:golden) WHERE g.cid="Golden123"
MATCH (adv:persona) WHERE adv.sourceSystemId="ADV123"
CREATE (adv)-[:ADVANCE]->(g)


### Example Queries
MATCH (a:persona),(b:persona)
WHERE a.name = 'Al Wirtes' AND b.name = 'Albert Wirtes'
CREATE (a)-[r:RELTYPE]->(b)
RETURN type(r)





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

// Run separately
MATCH (f:fund) WHERE f.name="College Radio Station"
MATCH (Alisha:persona) WHERE Alisha.sourceSystemId="CS1234"
CREATE (Alisha)-[:VOLUNTEER]->(f)


// Create Social Media Relationships between person1 (Al) and person2 (Alisha)
MATCH (s1:social) WHERE s1.name="@al_wirtes"
MATCH (s2:social) WHERE s2.name="@alisha_alisha"
CREATE (s1)-[:FOLLOWS]->(s2)
CREATE (s2)-[:FOLLOWS]->(s1)




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



DEMO QUERIES:
-------------

// Find my Golden Record:
MATCH (g:golden {name:"Al Wirtes"}) 
RETURN g


// Find connections between Robert Sudo and Alisha Sweeney
MATCH path = (p1:persona {name:"Robert Sudo"})-[*]-(p2:persona {name:"Alisha Sweeney"})
RETURN path
ORDER BY LENGTH(path) LIMIT 1
// **Remove ORDER BY to get all connections, leave in to get the shortest path**


