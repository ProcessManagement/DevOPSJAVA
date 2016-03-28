package com.meread.buildenv.test;

import com.meread.buildenv.test.entity.BookShelf;
import com.meread.buildenv.test.entity.Employee;
import com.meread.buildenv.test.entity.UDBookShelf;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.ServerAddress;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mongodb.morphia.Datastore;
import org.mongodb.morphia.Morphia;
import org.mongodb.morphia.query.Query;
import org.mongodb.morphia.query.UpdateOperations;
import org.mongodb.morphia.query.UpdateResults;

import java.util.Arrays;
import java.util.List;

/**
 * Created by yangxg on 16/1/26.
 */
public class MorphiaTest {

    MongoClient localMongos;
    MongoClient serverMongos;
    Datastore datastore;

    @Before
    public void initMongoClient() {
        MongoClientOptions mcops = new MongoClientOptions.Builder().connectionsPerHost(50).build();
//        :27017,10.13.27.237:27017,10.13.27.216:27017
        localMongos = new MongoClient(Arrays.asList(new ServerAddress("11.11.11.101", 30000),
                new ServerAddress("11.11.11.102", 30000), new ServerAddress("11.11.11.103", 30000)), mcops);
        serverMongos = new MongoClient("10.13.23.61", 27017);

        final Morphia morphia = new Morphia();
        morphia.mapPackage("com.meread.buildenv");
        datastore = morphia.createDatastore(localMongos, "mydb");
        datastore.ensureIndexes();
    }

    @Test
    public void serverTest() {
//        MongoDatabase bookshelf = serverMongos.getDatabase("testDB");
//        MongoCollection<Document> bookShelf = bookshelf.getCollection("BookShelf");
//        long count = bookShelf.count();
//        System.out.println(count);

        final Morphia morphia = new Morphia();
        final Datastore datastore = morphia.createDatastore(serverMongos, "testDB");
        List<UDBookShelf> result = datastore.createQuery(UDBookShelf.class).limit(10).asList();
        for (UDBookShelf bs : result) {
            System.out.println(bs);
        }

        List<BookShelf> result2 = datastore.createQuery(BookShelf.class).limit(10).asList();
        for (BookShelf bs : result2) {
            System.out.println(bs);
        }
    }

    @Test
    public void query() {
        List<Employee> all = datastore.createQuery(Employee.class).asList();
        for (Employee employee : all) {
            System.out.println(employee);
        }
    }

    @Test
    public void helloWorld() {

        datastore.delete(datastore.createQuery(Employee.class));

        final Employee ca = new Employee("我擦1", 50000.0);
        datastore.save(ca);

        final Employee cao = new Employee("我草1-1", 40000.0);
        datastore.save(cao);

        final Employee qu = new Employee("我去", 25000.0);
        datastore.save(qu);

        final Employee yun = new Employee("我晕1-2", 27500.0);
        datastore.save(yun);

        ca.getDirectReports().add(cao);
        ca.getDirectReports().add(yun);
        ca.setManager(qu);

        datastore.save(ca);

        Query<Employee> query = datastore.createQuery(Employee.class);
        final List<Employee> employees = query.asList();

        Assert.assertEquals(4, employees.size());

        List<Employee> underpaid = datastore.createQuery(Employee.class)
                .filter("salary <=", 30000)
                .asList();
        Assert.assertEquals(2, underpaid.size());

        underpaid = datastore.createQuery(Employee.class)
                .field("salary").lessThanOrEq(30000)
                .asList();
        Assert.assertEquals(2, underpaid.size());

        final Query<Employee> underPaidQuery = datastore.createQuery(Employee.class)
                .filter("salary <=", 30000);
        final UpdateOperations<Employee> updateOperations = datastore.createUpdateOperations(Employee.class)
                .inc("salary", 10000);

        final UpdateResults results = datastore.update(underPaidQuery, updateOperations);

        Assert.assertEquals(2, results.getUpdatedCount());

        final Query<Employee> overPaidQuery = datastore.createQuery(Employee.class)
                .filter("salary >", 100000);
        datastore.delete(overPaidQuery);


    }
}


