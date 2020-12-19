<html>
<head>
  <title>Todo List 0.001</title>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
  <link href="https://www.w3schools.com/w3css/4/w3.css" rel="stylesheet" />
</head>
<body>
%include("header.tpl", session=session)
<div class="new-item-ctn w3-container" style="
    display: flex;
    flex-direction: column;
    align-items: center;
">
<p class="w3-large">New Task</p>
<form action="/new_item" method="POST">
    <input type="text" size="100" maxlength="100" name="new_task"/>
    <input type="submit" name="save" value="Save"/>
</form>
%include("footer.tpl", session=session)
</div>
</body>
</html>