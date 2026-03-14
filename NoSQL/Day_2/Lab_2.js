//Use Inventory Collection or Order  any Collection 
//switch to ITI_Mongo database 
use ITI_Mongo
db.inventory.find()
//----------------------------------------------------------------------------------------------------------------

//1.	Find documents where the "tags" field exists.
db.inventory.find({ tags: { $exists: true } })

//----------------------------------------------------------------------------------------------------------------
//2.	Find documents where the "tags" field does not contain values "ssl" or "security."
//using $nin
db.inventory.find({
    tags: { $nin: ["ssl", "security"] ,$exists: true}
})

//----------------------------------------------------------------------------------------------------------------
//3.	Find documents where the "qty" field is equal to 85.
db.inventory.find({ qty: 85 })

//----------------------------------------------------------------------------------------------------------------
//4.	Find documents where the "tags" array contains all of the values [ssl, security] using the `$all` operator.
//ssl and security at least 
db.inventory.find({ tags: { $all: ["ssl", "security"],$size:2 } })

//----------------------------------------------------------------------------------------------------------------
//5.	Find documents where the "tags" array has a size of 3.
//match condition size of array = 3
db.inventory.find({ tags: { $size: 3 } })

//----------------------------------------------------------------------------------------------------------------
//6.	Update the "item" field in the "paper" document, update "size.uom" to "meter" and using the `$currentDate` operator.

db.inventory.find({ item: "paper" }) //check before update

db.inventory.updateOne(
    { item: "paper" },
    {
        $set: {
            "size.uom": "meter"
        },
        $currentDate:{
            updateDate:true //add currrent date as update date
        }
    })

db.inventory.find({ item: "paper" }) //check for update success

//------------------------------
//a.	Also, use the upsert option (within updateOne)and change filter condition item:”laptopDevice”.
db.inventory.find({ item: "laptopDevice" }) //check before update
//no document with item:laptopDevice
db.inventory.updateOne(
    { item: "laptopDevice" },
    {
        $set: {
            "size.uom": "meter"
        }
    },
    {
        upsert: true
    })
    //inserts new document with id>objectid , item > laptopDevice, size with child uom > meter


db.inventory.find({ item: "laptopDevice" }) //check for update success
//the document with item:laptopDevice inserted

//------------------------------
//b.	Use the $setOnInsert operator to add new data if an insert occurs. Example field: dataSource: "todayRegister"
db.inventory.find({ item: "laptops" }) //check before update
//no document with item:laptops

db.inventory.updateOne(
    { item: "laptops" },
    {
        $set: {
            "size.uom": "meter"
        },
        $setOnInsert: {
            dataSource: "todayRegister"
        }
    },
    {
        upsert: true
    })
//document inserted and field datasource added
db.inventory.find({ item: "laptops" }) //check for update success

//------------------------------
//c.	Try using the updateMany operation.
db.inventory.find({"item" : "paper"})
db.inventory.updateMany({"item" : "paper"},
{
    $set:{
        qty:150
    }
})
db.inventory.find({"item" : "paper"})

//------------------------------
//d.	Try using the `replaceOne` operation.
db.inventory.find({item:"nuts"})
db.inventory.replaceOne({item:"nuts"},{
    item:"car",
    quantity:1,
    price:120000
})
db.inventory.find({item:"nuts"})
db.inventory.find({item:"car"})
//replaceOne replaces all document with new one but update updates specific fields only

//----------------------------------------------------------------------------------------------------------------
//7.	Insert a document with incorrect field names "neme" and "ege," then rename them to "name" and "age."

db.inventory.insertOne({neme:"samuel",ege:23})
db.inventory.find({neme:"samuel"})
db.inventory.find()

db.inventory.updateOne(
  { neme: "samuel" },
  {
    $rename: {
      "neme": "name",
      "ege": "age"
    }
  }
)

db.inventory.find()

//----------------------------------------------------------------------------------------------------------------
//8.	Try to reset any document field using the `$unset` function.

db.inventory.updateOne(
  { name: "samuel" },
  { $unset: { age: "" } }
) //deletes field for all documents that match filter condition
db.inventory.find({name:"samuel"})

//---------------------------------------------------------------------------------------------------------------
//9.	Try update operators like `$inc`, `$min`, `$max`, and `$mul` to modify document fields.
//Important: Use a different field for each operation listed below. Insert Data If Not Existing
//Apply the following MongoDB update operators to the specified fields:
//----------------------------------------------------------------------------------------------------------------
//•	Use $max on the field: salary

db.employees.find({department:"Sales"}) //first match values salary =60000
db.employees.updateMany({department:"Sales"},{
    $max:{salary:58500}
}) //55000 , 58000 less than max so updated to 58500
db.employees.find({department:"Sales"}) 
//------------
db.employees.find({department:"Sales"})
db.employees.updateMany({department:"Sales"},{
    $max:{salary:50000} // no value is less than new max so no updates
}) 
db.employees.find({department:"Sales"}) 
//----------------------------------------------------------------------------------------------------------------

//•	Use $min on the field: overtime
//add overtime field for some employees
db.employees.updateOne({name:"John Doe"},{$set:{overTime:10}})
db.employees.updateOne({name:"Alice Smith"},{$set:{overTime:15}})
db.employees.updateOne({name:"Sarah Brown"},{$set:{overTime:20}})
db.employees.find()

db.employees.find({department:"Sales"}) 
db.employees.updateMany({department:"Sales"},{
    $min:{overTime:15}
}) //new value 15 less than current 20 so updated to 15
db.employees.find({department:"Sales"}) 

db.employees.find({department:"Sales"}) 
db.employees.updateMany({department:"Sales"},{
    $min:{overTime:20}
}) //no value greated than 20 so no updates
db.employees.find({department:"Sales"}) 
//----------------------------------------------------------------------------------------------------------------
//•	Use $inc on the field: age
db.employee.find({}) 
db.employee.updateOne({fName:"noha"},{$inc:{age:2}}) //before 25 after 27
db.employee.find({}) 
//----------------------------------------------------------------------------------------------------------------
//•	Use $mul on the fields: quantity and price
db.orders.find()
db.orders.updateMany({size:"large"},{$mul:{price:1.2,quantity:2}})
db.orders.find()

//----------------------------------------------------------------------------------------------------------------
//10.	Calculate the total revenue for product from sales collection documents within the date range
// '01-01-2020' to '01-01-2023' and then sort them in descending order by total revenue.
//a.	Total Revenue=  Sum (Quantity * Price)
//stages 1-match by dates >> 2-groupby product &sum >> 3-sorting desc by total revenue
db.sales.find()
db.sales.aggregate([{$match:{date:{$gte:new Date('2020-01-01'),$lte:new Date('2023-01-01')}}},
{$group:{
    _id:"$product",
    totalRevenue:{$sum:{$multiply:["$quantity","$price"]}}
}},
{$sort:{totalRevenue:-1}}
])

//----------------------------------------------------------------------------------------------------------------
//11.	Calculate the average salary for employees for each department from the employee’s collection.
db.employees.find()
db.employees.aggregate([
{$group:{
    _id:"$department",
    avgPerDept:{$avg:"$salary"}
}}
])

//----------------------------------------------------------------------------------------------------------------
//12.	Use likes Collection to calculate max and min likes per title
db.likes.find()
db.likes.aggregate([
  {
    $group: {
      _id: "$title",               
      maxLikes: { $max: "$likes" }, 
      minLikes: { $min: "$likes" }  
    }
  }
])