#!/usr/bin/python3
import psycopg2, cgi
import login
from helpers import print_html

form = cgi.FieldStorage()

cust_no = form.getvalue('cust_no')

sku = form.getvalue('sku')

tin = form.getvalue('tin')

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">')
print('<link href="static/style.css" rel="stylesheet">')
print('<title>Remove</title>')
print('</head>')
print('<body>')
connection = None
try:
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    if cust_no:
      # Check if customer exists
      sql = 'SELECT * FROM customer WHERE cust_no = %s;'
      cursor.execute(sql, (cust_no,))
      customer = cursor.fetchone()

      if customer is not None:
        # Remove customer from all table rows
        sql = 'START TRANSACTION; DELETE FROM customer WHERE cust_no = %s; DELETE FROM "order" WHERE cust_no = %s; DELETE FROM pay WHERE cust_no = %s; COMMIT;'
        data = (cust_no, cust_no, cust_no)
        cursor.execute(sql, data)
      
        # Commit the update (without this step the database will not change)
        connection.commit()
        
        print_html('Remove Customer', 'Customer Removed')
      
      else:
        print_html('Remove Customer', 'Customer does not exist')

    elif sku:
       # Check if product exists
       sql = 'SELECT * FROM product WHERE SKU = %s;'
       cursor.execute(sql, (sku,))
       product = cursor.fetchone()

       if product is not None:
          # Get all orders that contain the product to be removed
          sql = 'SELECT order_no FROM contains WHERE SKU = %s;'
          cursor.execute(sql, (sku,))
          orders = cursor.fetchall()

          # For each order with the product
          for order_no in orders:
             # Count how many products the order contains
             sql = 'SELECT COUNT(SKU) FROM contains WHERE order_no= %s;'
             cursor.execute(sql, (order_no,))
             count = cursor.fetchall()

             # If the product to be removed is the only product on that order 
             if count == 1:
                # Delete order from order table and contains table
                sql = 'START TRANSACTION; DELETE FROM "order" WHERE order_no = %s; DELETE FROM contains WHERE order_no = %s; DELETE FROM pay WHERE order_no = %s; DELETE FROM "process" WHERE order_no = %s; COMMIT;'
                data = (order_no, order_no, order_no, order_no)
                cursor.execute(sql, data)
            
          sql = 'DELETE FROM product WHERE SKU = %s;'
          cursor.execute(sql, (sku,))

          connection.commit()
         
          print_html('Remove Product', 'Product Removed')
        
       else:
          print_html('Remove Product', 'Product does not exist')

    elif tin:
        # Check if supplier exists
        sql = 'SELECT * FROM supplier WHERE TIN = %s;'
        cursor.execute(sql, (tin,))
        supplier = cursor.fetchone()

        if supplier is not None:
         # Get supplier product
         sql = 'SELECT SKU FROM supplier WHERE TIN = %s;'
         cursor.execute(sql, (tin,))
         sku = cursor.fetchone()

         # Check if there are more suppliers for the same product
         sql = 'SELECT COUNT(*) FROM supplier WHERE SKU = %s;'
         cursor.execute(sql, (sku,))
         count = cursor.fetchall()

         # Delete every table row that contains the supplier
         sql = 'START TRANSACTION; DELETE FROM supplier WHERE TIN = %s; DELETE FROM delivery WHERE TIN = %s; COMMIT;'
         data = (tin, tin)
         cursor.execute(sql, data)

         # If this was the only supplier delete the product
         if count == 1:
            # Get all orders that contain the product to be removed
            sql = 'SELECT order_no FROM contains WHERE SKU = %s;'
            cursor.execute(sql, (sku,))
            orders = cursor.fetchall()

            # For each order with the product
            for order_no in orders:
               # Count how many products the order contains
               sql = 'SELECT COUNT(SKU) FROM contains WHERE order_no= %s;'
               cursor.execute(sql, (order_no,))
               count = cursor.fetchall()

               # If the product to be removed is the only product on that order 
               if count == 1:
                  # Delete order from order table and contains table
                  sql = 'START TRANSACTION; DELETE FROM "order" WHERE order_no = %s; DELETE FROM contains WHERE order_no = %s; DELETE FROM pay WHERE order_no = %s; DELETE FROM "process" WHERE order_no = %s; COMMIT;'
                  data = (order_no, order_no, order_no, order_no)
                  cursor.execute(sql, data)

            sql = 'DELETE FROM product WHERE SKU = %s;'
            cursor.execute(sql, (sku,))
         
         connection.commit()
         
         print_html('Remove Supplier', 'Supplier Removed')

        else:
           print_html('Remove Supplier', 'Supplier does not exist')

    cursor.close()
        
except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred.</h1>')
    print('<p>{}</p>'.format(e))
finally:
    if connection is not None:
        connection.close()
print('</body>')
print('</html>')