<html>
<head>
  <title>Todo List 0.001</title>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
  <link href="https://www.w3schools.com/w3css/4/w3.css" rel="stylesheet" />
</head>
<body>
%include("header.tpl", session=session)
<div class="error-ctn w3-container" style="
    display: flex;
    flex-direction: column;
    align-items: center;
">
<p class="w3-large">Login</p>
<form action="/" method="GET">
    That login attempt didn't work out.
    <hr>
    <input type="submit" name="submit" value="OK"/>
</form>
%include("footer.tpl", session=session)
</div>
</body>
</html>