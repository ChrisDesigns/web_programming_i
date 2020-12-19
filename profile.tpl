<html>
<head>
<title>Todo List 0.001</title>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
<link href="https://www.w3schools.com/w3css/4/w3.css" rel="stylesheet" >
<style>
    .profile-icon {
        font-size: 10em;
        color: #009688;
        margin: 1rem;
    }
</style>
</head>
<body>
%include("header.tpl", session=session)
<div class="register-ctn w3-container" style="
    display: flex;
    flex-direction: column;
    align-items: center;
">
    <div style="profile-ctn"><i class="material-icons profile-icon">account_circle</i></div>
    <span>User Name: <input type="text" name="username" style="display: flex; width: 20em;" value="{{session['username']}}" disabled/></span>
    <br />
    <form action="/changePass" method="POST">
        Password: <input type="password" maxlength="100" name="password1" style="display: flex; width: 20em;"/>
        Retype Password:  <input type="password" maxlength="100" name="password2" style="display: flex; width: 20em;"/><br />
        <input type="submit" name="changePass" value="Change Password"/>
    </form>
</div>
%include("footer.tpl", session=session)
</body>
</html>