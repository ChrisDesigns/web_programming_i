<h3 class="w3-block w3-grey w3-center" style="margin: 0;">Basic Todo List, version 1.1</h3>
<div class="w3-bar w3-teal">
  % if 'username' in session and session['username'] != 'Guest':
      <a href="/"><button class="w3-bar-item w3-button">Home</button></a>
      <a href="/new_item"><button class="w3-bar-item w3-button">New item...</button></a>
      <a href="/profile"><button class="w3-bar-item w3-button">Profile</button></a>
      <a href="/logout"><button class="w3-bar-item w3-button">Logout</button></a>
  % else:
      <a href="/login"><button class="w3-bar-item w3-button">Login</button></a>
      <a href="/register"><button class="w3-bar-item w3-button">Register</button></a>
  % end
</div>