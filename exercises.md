# Exercises
Now that you have a basic graph of person data, here are some exercises that use this graph. 

_Turn down the triangle before the question to reveal the answer._

<details> 
  <summary><strong>Q0: Write a query that returns all nodes and relationships in the graph. Limit the number of rows returned to 50 as a best practice.</strong></summary>

```
MATCH (n) RETURN n LIMIT 50;
```
</details>

<details> 
  <summary><strong>Q1: Write a query that returns all nodes with a <code>name</code> attribute that contain the name "Wirtes".</strong></summary>

```
MATCH (n)
WHERE TOLOWER(n.name) CONTAINS 'wirtes'
RETURN n;
```
</details>

<details> 
  <summary><strong>Q2: Write a query that returns only nodes of type "persona" with a <code>name</code> attribute that contain the name "Wirtes".</strong></summary>

```
MATCH (n:persona)
WHERE TOLOWER(n.name) CONTAINS 'wirtes'
RETURN n;
```
</details>

<details> 
  <summary><strong>Q3: Create a node of type "golden" for Robert Smith with a <code>cid</code> attribute of "Golden11" and a <code>name</code> attribute of "Robert Smith." Relate this new node to Robert Smith's existing node with a relationship type "HCM".</strong></summary>

```
// Create Robert Smith Golden node
// Match HCM records for Robert Smith and create a golden record 
 MATCH (a:persona) WHERE a.name = 'Robert Smith' // HCM
 CREATE (g:golden {name:"Robert Smith", cid:"Golden11"})
//Create relationship to the source record
 CREATE (a)-[:HCM]->(g)
 RETURN a, g
```
This should return these nodes and relatioship:
<img width="659" alt="Screenshot 2024-09-16 at 5 17 57 PM" src="https://github.com/user-attachments/assets/0f3a8525-84b7-4695-9f0f-9368a5b0b5d8">
</details>

