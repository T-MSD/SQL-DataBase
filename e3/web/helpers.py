# Display error/confirmation message
def print_html(title, text):
   print('<div class="header">')
   print('<h1>{}</h1>'.format(title))
   print('</div>')
   print('<div class="container">')
   print('<h1>{}<h1>'.format(text))
   print('<form action="templates/MainPage.html" method="post">')
   print('<input type="submit" value="Return to Main Page">')
   print('</form>')
   print('</div>')