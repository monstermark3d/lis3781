use test
show collecions

// 1

db.restaurants.find();

// 2

db.restaurants.find().count();

// 3

db.restaurants.find().limit(5);

// 4

db.restaurants.find({"borough": "Brooklyn"})

// 5

db.restaurants.find({"cuisine": "American "});

db.restaurants.find({"cuisine": /^american\s$/i})

// 6

db.restaurants.find({"borough": "Brooklyn", "cuisine": "Hamburgers"});

// 7

db.restaurants.find({"borough": "Manhattan", "cuisine": "Hamburgers"}).count();

// 8

db.restaurants.find( {"address.zipcode" : "10075"})

// 9

db.restaurants.find({"cuisine": "Chicken", "address.zipcode" : "10024"});

db.restaurants.find({$and: [{"cuisine": "Chicken"}, {"address.zipcode" : "10024"}]});

// 10

db.restaurants.find({$or: [{"cuisine": "Chicken"}, {"address.zipcode" : "10024"}]});

// 11

db.restaurants.find( { "borough": "Queens", "cuisine": "Jewish/Kosher"}).sort({"address.zipcode": -1})

db.restaurants.find( {$and: [{ "borough": "Queens"}, {"cuisine": "Jewish/Kosher"}]}).sort({"address.zipcode": -1})

// 12

db.restaurants.find( {"grades.grade": "A"})

// 13

db.restaurants.find( {"grades.grade": "A"},{"name": 1, "grades.grade":1})

// 14

db.restaurants.find( {"grades.grade": "A"},{"name": 1, "grades.grade":1, _id: 0})

// 15

db.restaurants.find( {"grades.grade": "A"}).sort({"cuisine": 1, "address.zipcode": -1})

// 16

db.restaurants.find( { "grades.score": {$gt: 80}})

// 17

db.restaurants.insert(
    {
    address: {
        building: '1000',
        coord: [ -58.9557413, 31.7720266 ],
        street: '7th Avenue',
        zipcode: '10024'
    },
    borough: 'Brooklyn',
    cuisine: 'BBQ',
    grades: [
        { date: ISODate('2015-11-05T00:00:00Z'), grade: 'C', score: 15 }
    ],
    name: 'Big Tex',
    restaurant_id: '61704627'
    }
)

db.restaurants.find().sort({_id:-1}).limit(1).pretty()

// 18

db.restaurants.find( { "name" : "White Castle"} ).limit(1)

db.restaurants.updateOne(
    { _id: ObjectId('69e03378fd7ab1710a25a28c')},
    {
        $set: { "cuisine": "Steak and Sea Food" }, $currentDate: {"lastModified":true}  
    }
)

// 19

db.restaurants.find( { "name" : "White Castle"} ).count()

db.restaurants.remove( { "name" : "White Castle"} )

db.restaurants.find( { "name" : "White Castle"} ).count()