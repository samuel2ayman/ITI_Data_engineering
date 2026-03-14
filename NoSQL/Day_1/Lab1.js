//1.	Create a Database named "ITI_Mongo".

//In MongoDB, using use "dbname" switches to the database if it exists or prepares to create it if it doesn’t. 
//The database is only actually created when you insert data into it.
use ITI_Mongo

//2.	Create a Collection named "Staff".
//3.	Insert one document into the "Staff" collection: {_id, name, age, gender, department}.
//Create collection and insert one document in one command as collection is created automatically when i insert data

db.Staff.insertOne({
   "_id":1,
   "name":"samuel",
   "age":23,
   "gender":"male",
   "department":"Data Engineering"
})

//4.	Insert many documents into the "Staff" collection:

db.Staff.insertMany([
   {
      "_id":2,
      "name":"Mina",
      "age":20,
      "gender":"male",
      "department":"Data Engineering"
   },
   {
      "_id":3,
      "name":"Rana",
      "age":25,
      "gender":"female",
      "managerName":"Samuel",
      "department":"Finance"
   },
   {
      "_id":4,
      "name":"Nada",
      "age":15,
      "gender":"female",
      "DOB":ISODate("04-25-2007")
   }
])
db.Staff.find()
//5.	Query to find data from the "Staff" collection:
//•	1) Find all documents.

db.Staff.find()

//•	2) Find documents where gender is "male".

db.Staff.find({gender:"male"})


//•	3) Find documents with age between 20 and 25.

db.Staff.find({
    age:{$gte:20,$lte:25}
})


//•	4) Find documents where age is 25 and gender is "female".

db.Staff.find({age:25,gender:"female"})

//•	5) Find documents where age is 20 or gender is "female".

db.Staff.find({
    $or:[
    {age:20},
    {gender:"female"}
    ]})


//6.	Update one document in the "Staff" collection where age is 15, set the name to "your name".
//if many documents have age = 15 only first one will be updated
db.Staff.updateOne({age:15},{$set:{name:"sam"}})

//7.	Update many documents in the "Staff" collection, update the department to "AI".

db.Staff.updateMany({},{$set:{department:"AI"}})


//8.	Create a new collection called "test" and insert documents from Question 4.
//will create the collection automatically

db.test.insertMany([
   {
      "_id":2,
      "name":"Mina",
      "age":20,
      "gender":"male",
      "department":"Data Engineering"
   },
   {
      "_id":3,
      "name":"Rana",
      "age":25,
      "gender":"female",
      "managerName":"Samuel",
      "department":"Finance"
   },
   {
      "_id":4,
      "name":"Nada",
      "age":15,
      "gender":"female",
      "DOB":"04-25-2007"
   }
])


//9.	Try to delete one document from the "test" collection where age is 15.

db.test.deleteOne({age:15})
db.test.find()
//a.	With justification, explain which document will be deleted if more than one has age = 15. (Try it.)
//b.	First insert: db.collection.insertOne({ _id: 5, name: "ahmed", age: 15 })

db.test.insertOne({ _id: 5, name: "ahmed", age: 15 })

//c.	Second insert: db.collection.insertOne({ _id: 6, name: "eman", age: 15 })

db.test.insertOne({ _id: 6, name: "eman", age: 15 })

//d.	b. When you run deleteOne, will it delete ahmed or eman?
/*This code will delete the first occurance if i specified order so deletes the first if not
 it deletes first(in insertion order) document in collection matches the filter*/
 
db.test.deleteOne({age:15})
db.test.find()

//10.	 try to delete all male gender

db.test.insertOne({ _id: 4, name: "ahmed", age: 17,gender:"male" })
db.test.deleteMany({gender:"male"})


//11.	Try to delete all documents in the "test" collection.

db.test.deleteMany({})
db.test.find()
