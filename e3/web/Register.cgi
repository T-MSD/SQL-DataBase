#!/usr/bin/python3
import psycopg2, cgi
import login
from helpers import print_html

form = cgi.FieldStorage()

cust_no = form.getvalue('cust_no')
email = form.getvalue('email')
phone = form.getvalue('phone')
client_address = form.getvalue('client_address')
client_name = form.getvalue('client_name')

product_sku = form.getvalue('product_sku')
product_name = form.getvalue('product_name')
description = form.getvalue('description')
price = form.getvalue('price')
ean = form.getvalue('ean')

tin = form.getvalue('tin')
supplier_name = form.getvalue('supplier_name')
supplier_address = form.getvalue('supplier_address')
supplier_sku = form.getvalue('supplier_sku')
date = form.getvalue('date')

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">')
print('<link href="static/style.css" rel="stylesheet">')
print('<title>Resgister</title>')
print('</head>')
print('<body>')
connection = None
try:
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    if cust_no and email and phone and client_address and client_name:
      # Check if customer exists
      sql = 'SELECT * FROM customer WHERE cust_no = %s OR email = %s;'
      data = (cust_no, email)
      cursor.execute(sql, data)
      customer = cursor.fetchone()

      if int(cust_no) < 0:
         print_html('Register Customer', "Customer number can't be negative")

      elif customer is None:
        # Create new customer
        sql = 'INSERT INTO customer VALUES (%s, %s, %s, %s, %s);'
        data = (cust_no, client_name, email, phone, client_address)

        cursor.execute(sql, data)
      
        # Commit the update (without this step the database will not change)
        connection.commit()
        
        print_html('Register Customer', 'Customer Created')
      
      else:
        print_html('Register Customer', 'Customer already exists')

    elif product_sku and description and price and product_name:
       # Check if product exists
       sql = 'SELECT * FROM product WHERE SKU = %s;'
       cursor.execute(sql, (product_sku,))
       product = cursor.fetchone()

       error = False

       # Since the are products without EAN
       if ean:
         if not ean.isdigit():
            error = True
            print_html('Register Product', 'Product EAN must be a numeric sequence')
         
         elif int(ean) < 0:
            error = True
            print_html('Register Product', "Product EAN can't be negative")
      
       if product is None and not error:
         # Create product
         sql = 'INSERT INTO product VALUES (%s, %s, %s, %s, %s);'
         data = (product_sku, product_name, description, price, ean)
         cursor.execute(sql, data)

         connection.commit()

         print_html('Register Product', 'Product Created')

       else:
         print_html('Register Product', 'Product already exists')
      
    elif tin and supplier_name and supplier_address and supplier_sku and date:
       # Check if supplier exists
       sql = 'SELECT * FROM supplier WHERE TIN = %s;'
       cursor.execute(sql, (tin,))
       supplier = cursor.fetchone()

       if supplier is None:
         # Create supplier
         sql = 'INSERT INTO supplier VALUES (%s, %s, %s, %s, %s);'
         data = (tin, supplier_name, supplier_address, supplier_sku, date)
         cursor.execute(sql, data)

         connection.commit()
         
         print_html('Register Supplier', 'Supplier Created')
        
       else:
         print_html('Register Supplier', 'Supplier already exists')

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