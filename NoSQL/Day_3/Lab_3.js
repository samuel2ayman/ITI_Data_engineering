/*1.	Provide the MongoDB code for enforcing JSON schema validation when creating a collection named "employees"
 with required fields "name," "age" (min. 18), and "department" (limited to ["HR," "Engineering," "Finance"]).*/
use validatoin
db.createCollection("employees",{  
    validator:{        //applied to new data only and followed in insert an update
        $jsonSchema:{
            bsonType:"object",
            title:"employee info validation",
            required:["name","age","department"],
            properties:{
                age:{
                    bsonType:"int",
                    minimum:18,
                    description:"age must be older than 18"
                },
                department:{
                    bsonType:"string",
                    enum:["HR", "Engineering", "Finance"],
                    description:"department should be HR or Engineering or Finance"
                    
                }
            }
        }
    }
})
db.employees.insertOne({name:"sam"}) // Fails "missingProperties" : ["age","department"]
db.employees.insertOne({name:"sam",age:5,department:"HR"}) // Fails "description" : "age must be older than 18"
db.employees.insertOne({name:"sam",age:23,department:"data"}) //fails "reason" : "value was not found in enum"
db.employees.insertOne({name:"sam",age:25,department:"HR"})  //insertion done
db.employees.find()
//_________________________________________________________________________________________________

//2.	Create new Database named Demo
//And Collections named trainningCenter1, trainningCenter2 
use Demo
db.createCollection("trainningCenter1")
db.createCollection("trainningCenter2")
//_________________________________________________________________________________________________

//a.	Insert documents into trainningCenter1 collection contains (Use Variable named data as Array)
//i.	_id , name as firstName lastName , age , address, status as array 
var data=[
 { _id: 1, fName: "karim", lName: "hassan", age: 19, address: "Alexandria", status: "inactive" },
 { _id: 2, fName: "sara", lName: "adel", age: 28, address: "Cairo", status: "active" },
 { _id: 3, fName: "youssef", lName: "nabil", age: 34, address: "Giza", status: "inactive" },
 { _id: 4, fName: "laila", lName: "fathy", age: 41, address: "Mansoura", status: "active" },
 { _id: 5, fName: "omar", lName: "khaled", age: 52, address: "Aswan", status: "inactive" }
]
//_________________________________________________________________________________________________

//b.	Using insert ONE from data Variable
//data.forEach(function(document) {db.trainningCenter1.insertOne(document)}) //enumerate each document and insert ne by one
db.trainningCenter1.insertOne(data)
db.trainningCenter1.find()
//_________________________________________________________________________________________________

//c.	Using Same Variable (data) with same data and insert MANY into trainningCenter2 collection
db.trainningCenter2.insertMany(data)
db.trainningCenter2.find()
//_________________________________________________________________________________________________

//3.	Use find. explain function (find by age field) and mention scanning type
db.trainningCenter1.find({age:28}).explain() //"COLLSCAN"

//_________________________________________________________________________________________________
//4.	Create index on created collection named it “IX_age” on age field 
db.trainningCenter1.createIndex({age:1},{name:"IX_age"}) //ascending order index
//_________________________________________________________________________________________________
//5.	Use find. explain view winning plan for index created (find by age field) and mention scanning type
db.trainningCenter1.find({age:28}).explain() //"stage" : "IXSCAN","indexName" : "IX_age"
//_________________________________________________________________________________________________

//6.	Create index on created collection named it “compound” on firstName and lastName
db.trainningCenter2.createIndex({fName:1,lName:1},{name:"IX_compound"})
//_________________________________________________________________________________________________

//a.	Try find().explain before create index and mention scanning type
db.trainningCenter2.find({fName:"youssef",lName:"nabil"}).explain() //"stage" : "COLLSCAN" collection scan
//_________________________________________________________________________________________________

//b.	Try find().explain after create index and mention scanning type
db.trainningCenter2.find({fName:"youssef",lName:"nabil"}).explain() //"stage" : "IXSCAN", "indexName" : "IX_compound"
//also use compound index for first name only(left prefix rule)
db.trainningCenter2.find({fName:"youssef"}).explain()//"stage" : "IXSCAN", "indexName" : "IX_compound"

//_________________________________________________________________________________________________

//7.	Drop Demo Database
db.dropDatabase() //database and collections and documents dropped as hierarchy database>collections>documents


//Bonus Part
//1.	Use mongodump to back up your Lab database.
//mongodump --db ITI_Mongo --out E:\ITI\Projects\NoSQL\Day_3
//2.	Drop the Lab database.
use ITI_Mongo
db.dropDatabase()
//3.	Use mongorestore to restore it with a new name: ITI_Course.
//mongorestore --db ITI_Course --dir E:\ITI\Projects\NoSQL\Day_3\ITI_Mongo

