#!/usr/bin/python3
import psycopg2, cgi
import login
from helpers import print_html

form = cgi.FieldStorage()

sku_price = form.getvalue('sku_price')
price = form.getvalue('price')

sku_description = form.getvalue('sku_description')
description = form.getvalue('description')

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">')
print('<link href="static/style.css" rel="stylesheet">')
print('<title>Change</title>')
print('</head>')
print('<body>')
connection = None
try:
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    if sku_price and price:
      # Check if the product exists
      sql = 'SELECT * FROM product WHERE SKU = %s;'
      cursor.execute(sql, (sku_price,))
      product = cursor.fetchone()

      if product is not None:
        # If it exists update price
        sql = 'UPDATE product SET price = %s WHERE SKU = %s;'
        data = (price, sku_price)

        cursor.execute(sql, data)

        connection.commit()

        print_html('Change Price', 'Price Changed')
      
      else:
        print_html('Change Price', 'Product does not exist')

    elif sku_description and description:
      # Check if the product exists
      sql = 'SELECT * FROM product WHERE SKU = %s;'
      cursor.execute(sql, (sku_description,))
      product = cursor.fetchone()

      if product is not None:
        # If it exists update price
        sql = 'UPDATE product SET description = %s WHERE SKU = %s;'
        data = (description, sku_description)

        cursor.execute(sql, data)

        connection.commit()

        print_html('Change Description', 'Description Changed')
      
      else:
        print_html('Change Description', 'Product does not exist')

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