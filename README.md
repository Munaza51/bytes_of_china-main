# Bytes of China

## PostgreSQL Codecademy Project

### Design and Run Queries in a Simple Relational Database

This project demonstrates the design and querying of a relational database using PostgreSQL. It includes tables for a restaurant, its address, categories of dishes, individual dishes, reviews, and a cross-reference table for categories and dishes.

## How to Use the File

1. **Create a PostgreSQL Database**:
   - Start the `psql` command-line interface.
   - Create a new database:
     ```sql
     postgres=# CREATE DATABASE bytes_of_china;
     ```

2. **Import the SQL Script**:
   - Switch to the newly created database:
     ```sql
     postgres=# \c bytes_of_china;
     ```
   - Import the SQL script provided (`script.sql`) into the database:
     ```sql
     bytes_of_china=# \i /path/to/script.sql
     ```

3. **Run Queries**:
   - Use the following example queries to interact with the database:
     ```sql
     -- Example Query 1: List restaurant details with address
     SELECT r.name AS restaurant_name, r.telephone, a.street_name, a.street_number
     FROM restaurant r
     JOIN address a ON r.id = a.restaurant_id;
     ```

4. **Additional Notes**:
   - Customize and adjust the database schema, data, and queries based on your project requirements.
   - Ensure all SQL statements conform to PostgreSQL syntax and best practices.

For more detailed instructions and project documentation, refer to the `script.sql` file and additional resources provided.
