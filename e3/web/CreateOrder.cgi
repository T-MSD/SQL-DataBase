#!/usr/bin/python3
import psycopg2, cgi
import login
from datetime import datetime
import itertools
from helpers import print_html

form = cgi.FieldStorage()

cust_no = form.getvalue('cust_no')

# Create a list with all product skus
product_skus = []
for key in form.keys():
    if key.startswith('sku'):
        prod_sku = form.getvalue(key)
        product_skus.append(prod_sku)

# Create a list with all product quantities
product_qtys = []
for key in form.keys():
    if key.startswith('qty'):
        prod_qty = form.getvalue(key)
        product_qtys.append(prod_qty)

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">')
print('<link href="static/style.css" rel="stylesheet">')
print('<title>Order</title>')
print('</head>')
print('<body>')
connection = None
try:
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    error = False

    # Get todays date
    order_date = datetime.today().date()

    if int(cust_no) < 0:
        print_html('Create Order', "Customer number can't be less than 0")
        error = True
    
    for qty in product_qtys:
        if int(qty) < 1:
            print_html('Create Order', "Quantity can't be less than 1")
            error = True
            break

    if not error:
        # Check if the customer exists
        sql = 'SELECT * FROM customer WHERE cust_no = %s;'
        cursor.execute(sql, (cust_no,))
        customer = cursor.fetchone()

        if customer is None:
            print_html('Create Order', 'Customer does not exist')
            error = True

        # Check if all products exist
        for sku in product_skus:
            sql = 'SELECT * FROM product WHERE SKU = %s;'
            cursor.execute(sql, (sku,))
            product = cursor.fetchone()

            if product is None:
                print_html('Create Order', 'Product does not exist')
                error = True
                break
        
        if not error:
            order_no = 1

            # Count how many orders already exist
            sql = 'SELECT COUNT(*) FROM "order";'
            cursor.execute(sql)
            orders = cursor.fetchall()

            # If this is not the first order update order number
            if orders is not None:
                order_no = int(orders[-1][0]) + 1
            
            # Create order
            sql = 'INSERT INTO "order" VALUES (%s, %s, %s);'
            data = (order_no, cust_no, order_date.strftime('%Y-%m-%d'))
            cursor.execute(sql, data)
            
            # Iterate over both arrays and create all contains
            for (sku, qty) in itertools.zip_longest(product_skus, product_qtys):
                sql = 'INSERT INTO contains VALUES (%s, %s, %s);'
                data = (order_no, sku, qty)
                cursor.execute(sql, data)

            connection.commit()
            
            print_html('Create Order', 'Order Number <strong>{}</strong>'.format(order_no))

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