#!/usr/bin/python3
import psycopg2, cgi
import login
from helpers import print_html

form = cgi.FieldStorage()

cust_no = form.getvalue('cust_no')
order_no = form.getvalue('order_no')

print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">')
print('<link href="static/style.css" rel="stylesheet">')
print('<title>Pay Order</title>')
print('</head>')
print('<body>')
connection = None
try:
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    if cust_no and order_no:
      # Check if order exists in pay table
      sql = 'SELECT * FROM pay WHERE order_no = %s;'
      cursor.execute(sql, (order_no,))
      pay = cursor.fetchone()
      
      if int(cust_no) < 0:
        print_html('Pay Order', "Customer number can't be negative")
        
      elif int(order_no) < 0:
        print_html('Pay Order', "Order number can't be negative")

      elif pay is None:
        # Check if order exists
        sql = 'SELECT * FROM "order" WHERE order_no = %s AND cust_no = %s;'
        data = (order_no, cust_no)

        cursor.execute(sql, data)

        order = cursor.fetchone()
      
        if order is None:
          print_html('Pay Order', 'Order does not exist')
   
        else:
          # Pay order
          sql = 'INSERT INTO pay VALUES (%s, %s);'
          data = (order_no, cust_no)
          cursor.execute(sql, data)
          connection.commit()

          print_html('Pay Order', 'Your order has been paid')

      else:
         print_html('Pay Order', 'Your order has already been paid')
        
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