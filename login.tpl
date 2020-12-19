<html>
<head>
  <title>Todo List 0.001</title>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
  <link href="https://www.w3schools.com/w3css/4/w3.css" rel="stylesheet" />
</head>
<body>
%include("header.tpl", session=session)
<div class="login-ctn w3-container" style="
    display: flex;
    flex-direction: column;
    align-items: center;
">
    <p class="w3-large">Login</p>
    <form action="/login" method="POST">
        User Name: <input type="text" maxlength="100" name="username" style="display: flex; width: 20em;"/><br>
        Password:  <input type="password" maxlength="100" name="password" style="display: flex; width: 20em;"/><br>
        <input type="hidden" name="csrf_token" value="{{csrf_token}}"/><br>
        <input type="submit" name="login" value="Login"/>
    </form>
</div>
%include("footer.tpl", session=session)
</body>
</html>