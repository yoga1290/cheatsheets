# Outline
+ Java Persistence Query Language
  + Parameters with Dynamic Queries
  + Named Queries
  + Relationships
  + Criteria API
    + Joins
  + [Inheritance](#Inheritance)

## JPA Criteria API vs JPQL [[objectdb](https://www.objectdb.com/java/jpa/query/criteria)]
JPQL queries are defined as strings, similarly to SQL.
JPA criteria queries, on the other hand, are defined by instantiation of Java objects that represent query elements.
A major advantage of using the criteria API is that errors can be detected earlier, during compilation rather than at runtime. On the other hand, for many developers string based JPQL queries, which are very similar to SQL queries, are easier to use and understand.
For simple static queries - string based JPQL queries (e.g. as named queries) may be preferred. For dynamic queries that are built at runtime - the criteria API may be preferred.

For example, building a dynamic query based on fields that a user fills at runtime in a form that contains many optional fields - is expected to be cleaner when using the JPA criteria API, because it eliminates the need for building the query using many string concatenation operations.
String based JPQL queries and JPA criteria based queries are equivalent in power and in efficiency. Therefore, choosing one method over the other is also a matter of personal preference. 

## Named Queries
* compiled and validated at app start-up time.
* easier to maintain than string literals embedded in your code.
* HQL and native SQL queries can be used and replaced without code changes (no need to re-compile your code)

# ref:
* [[The best way to map the @DiscriminatorColumn with JPA and Hibernate](https://vladmihalcea.com/the-best-way-to-map-the-discriminatorcolumn-with-jpa-and-hibernate/)]


## Inheritance

+ @Inheritance(strategy = InheritanceType.**SINGLE_TABLE**)
  + the **default** behavior
  + example [[Vlad Mihalcea](https://vladmihalcea.com/the-best-way-to-map-the-discriminatorcolumn-with-jpa-and-hibernate/)] post
+ @Inheritance(strategy = InheritanceType.**JOINED**)
+ @Inheritance(strategy = InheritanceType.**TABLE_PER_CLASS**)

see [[Baeldung](https://www.baeldung.com/hibernate-inheritance)]
```java
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(
    discriminatorType = DiscriminatorType.INTEGER,
    name = "topic_type_id",
    columnDefinition = "TINYINT(1)"
)
@Entity @Table public class Topic{ @Id }

@DiscriminatorValue("1")
@Entity @Table public class Post extends Topic {}
```
